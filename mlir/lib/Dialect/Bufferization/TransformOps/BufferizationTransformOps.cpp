//===- BufferizationTransformOps.h - Bufferization transform ops ----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Bufferization/TransformOps/BufferizationTransformOps.h"

#include "mlir/Dialect/Bufferization/IR/Bufferization.h"
#include "mlir/Dialect/Bufferization/Transforms/OneShotAnalysis.h"
#include "mlir/Dialect/Bufferization/Transforms/OneShotModuleBufferize.h"
#include "mlir/Dialect/Bufferization/Transforms/Passes.h"
#include "mlir/Dialect/Bufferization/Transforms/Transforms.h"
#include "mlir/Dialect/Linalg/IR/Linalg.h"
#include "mlir/Dialect/MemRef/IR/MemRef.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/Dialect/Transform/IR/TransformDialect.h"
#include "mlir/Interfaces/FunctionInterfaces.h"

using namespace mlir;
using namespace mlir::bufferization;
using namespace mlir::transform;

//===----------------------------------------------------------------------===//
// BufferLoopHoistingOp
//===----------------------------------------------------------------------===//

DiagnosedSilenceableFailure transform::BufferLoopHoistingOp::applyToOne(
    TransformRewriter &rewriter, Operation *target,
    ApplyToEachResultList &results, TransformState &state) {
  bufferization::hoistBuffersFromLoops(target);
  return DiagnosedSilenceableFailure::success();
}

void transform::BufferLoopHoistingOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  onlyReadsHandle(getTargetMutable(), effects);
  modifiesPayload(effects);
}

//===----------------------------------------------------------------------===//
// OneShotBufferizeOp
//===----------------------------------------------------------------------===//

LogicalResult transform::OneShotBufferizeOp::verify() {
  if (getMemcpyOp() != "memref.copy" && getMemcpyOp() != "linalg.copy")
    return emitOpError() << "unsupported memcpy op";
  if (getPrintConflicts() && !getTestAnalysisOnly())
    return emitOpError() << "'print_conflicts' requires 'test_analysis_only'";
  if (getDumpAliasSets() && !getTestAnalysisOnly())
    return emitOpError() << "'dump_alias_sets' requires 'test_analysis_only'";
  return success();
}

DiagnosedSilenceableFailure
transform::OneShotBufferizeOp::apply(transform::TransformRewriter &rewriter,
                                     TransformResults &transformResults,
                                     TransformState &state) {
  OneShotBufferizationOptions options;
  options.allowReturnAllocsFromLoops = getAllowReturnAllocsFromLoops();
  options.allowUnknownOps = getAllowUnknownOps();
  options.bufferizeFunctionBoundaries = getBufferizeFunctionBoundaries();
  options.dumpAliasSets = getDumpAliasSets();
  options.testAnalysisOnly = getTestAnalysisOnly();
  options.printConflicts = getPrintConflicts();
  if (getFunctionBoundaryTypeConversion().has_value())
    options.setFunctionBoundaryTypeConversion(
        *getFunctionBoundaryTypeConversion());
  if (getMemcpyOp() == "memref.copy") {
    options.memCpyFn = [](OpBuilder &b, Location loc, Value from, Value to) {
      memref::CopyOp::create(b, loc, from, to);
      return success();
    };
  } else if (getMemcpyOp() == "linalg.copy") {
    options.memCpyFn = [](OpBuilder &b, Location loc, Value from, Value to) {
      linalg::CopyOp::create(b, loc, from, to);
      return success();
    };
  } else {
    llvm_unreachable("invalid copy op");
  }

  auto payloadOps = state.getPayloadOps(getTarget());
  BufferizationState bufferizationState;

  for (Operation *target : payloadOps) {
    if (!isa<ModuleOp, FunctionOpInterface>(target))
      return emitSilenceableError() << "expected module or function target";
    auto moduleOp = dyn_cast<ModuleOp>(target);
    if (options.bufferizeFunctionBoundaries) {
      if (!moduleOp)
        return emitSilenceableError() << "expected module target";
      if (failed(bufferization::runOneShotModuleBufferize(moduleOp, options,
                                                          bufferizationState)))
        return emitSilenceableError() << "bufferization failed";
    } else {
      if (failed(bufferization::runOneShotBufferize(target, options,
                                                    bufferizationState)))
        return emitSilenceableError() << "bufferization failed";
    }
  }

  // This transform op is currently restricted to ModuleOps and function ops.
  // Such ops are modified in-place.
  transformResults.set(cast<OpResult>(getTransformed()), payloadOps);
  return DiagnosedSilenceableFailure::success();
}

//===----------------------------------------------------------------------===//
// EliminateEmptyTensorsOp
//===----------------------------------------------------------------------===//

void transform::EliminateEmptyTensorsOp::getEffects(
    SmallVectorImpl<MemoryEffects::EffectInstance> &effects) {
  onlyReadsHandle(getTargetMutable(), effects);
  modifiesPayload(effects);
}

DiagnosedSilenceableFailure transform::EliminateEmptyTensorsOp::apply(
    transform::TransformRewriter &rewriter, TransformResults &transformResults,
    TransformState &state) {
  for (Operation *target : state.getPayloadOps(getTarget())) {
    if (failed(bufferization::eliminateEmptyTensors(rewriter, target)))
      return mlir::emitSilenceableFailure(target->getLoc())
             << "empty tensor elimination failed";
  }
  return DiagnosedSilenceableFailure::success();
}

//===----------------------------------------------------------------------===//
// EmptyTensorToAllocTensorOp
//===----------------------------------------------------------------------===//

DiagnosedSilenceableFailure EmptyTensorToAllocTensorOp::applyToOne(
    transform::TransformRewriter &rewriter, tensor::EmptyOp target,
    ApplyToEachResultList &results, transform::TransformState &state) {
  rewriter.setInsertionPoint(target);
  auto alloc = rewriter.replaceOpWithNewOp<bufferization::AllocTensorOp>(
      target, target.getType(), target.getDynamicSizes());
  results.push_back(alloc);
  return DiagnosedSilenceableFailure::success();
}

//===----------------------------------------------------------------------===//
// Transform op registration
//===----------------------------------------------------------------------===//

namespace {
/// Registers new ops and declares PDL as dependent dialect since the additional
/// ops are using PDL types for operands and results.
class BufferizationTransformDialectExtension
    : public transform::TransformDialectExtension<
          BufferizationTransformDialectExtension> {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(
      BufferizationTransformDialectExtension)

  using Base::Base;

  void init() {
    declareGeneratedDialect<bufferization::BufferizationDialect>();
    declareGeneratedDialect<memref::MemRefDialect>();

    registerTransformOps<
#define GET_OP_LIST
#include "mlir/Dialect/Bufferization/TransformOps/BufferizationTransformOps.cpp.inc"

        >();
  }
};
} // namespace

#define GET_OP_CLASSES
#include "mlir/Dialect/Bufferization/TransformOps/BufferizationTransformOps.cpp.inc"

#include "mlir/Dialect/Bufferization/IR/BufferizationEnums.cpp.inc"

void mlir::bufferization::registerTransformDialectExtension(
    DialectRegistry &registry) {
  registry.addExtensions<BufferizationTransformDialectExtension>();
}
