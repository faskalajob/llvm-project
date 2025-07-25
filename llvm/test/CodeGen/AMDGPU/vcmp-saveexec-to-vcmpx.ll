; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc -mtriple=amdgcn -mcpu=gfx1010 < %s | FileCheck -check-prefixes=GCN,GFX1010 %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx1030 < %s | FileCheck -check-prefixes=GCN,GFX1030 %s

define i32 @test_insert_vcmpx_pattern_lt(i32 %x) {
; GFX1010-LABEL: test_insert_vcmpx_pattern_lt:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-NEXT:    v_cmp_lt_i32_e32 vcc_lo, 15, v0
; GFX1010-NEXT:    s_and_saveexec_b32 s4, vcc_lo
; GFX1010-NEXT:  ; %bb.1: ; %if
; GFX1010-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX1010-NEXT:  ; %bb.2: ; %UnifiedReturnBlock
; GFX1010-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; GFX1010-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1030-LABEL: test_insert_vcmpx_pattern_lt:
; GFX1030:       ; %bb.0: ; %entry
; GFX1030-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1030-NEXT:    s_mov_b32 s4, exec_lo
; GFX1030-NEXT:    v_cmpx_lt_i32_e32 15, v0
; GFX1030-NEXT:  ; %bb.1: ; %if
; GFX1030-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX1030-NEXT:  ; %bb.2: ; %UnifiedReturnBlock
; GFX1030-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; GFX1030-NEXT:    s_setpc_b64 s[30:31]
entry:
  %bc = icmp slt i32 %x, 16
  br i1 %bc, label %endif, label %if

if:
  %ret = shl i32 %x, 2
  ret i32 %ret

endif:
  ret i32 %x
}

define i32 @test_insert_vcmpx_pattern_gt(i32 %x) {
; GFX1010-LABEL: test_insert_vcmpx_pattern_gt:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-NEXT:    v_cmp_gt_i32_e32 vcc_lo, 17, v0
; GFX1010-NEXT:    s_and_saveexec_b32 s4, vcc_lo
; GFX1010-NEXT:  ; %bb.1: ; %if
; GFX1010-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX1010-NEXT:  ; %bb.2: ; %UnifiedReturnBlock
; GFX1010-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; GFX1010-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1030-LABEL: test_insert_vcmpx_pattern_gt:
; GFX1030:       ; %bb.0: ; %entry
; GFX1030-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1030-NEXT:    s_mov_b32 s4, exec_lo
; GFX1030-NEXT:    v_cmpx_gt_i32_e32 17, v0
; GFX1030-NEXT:  ; %bb.1: ; %if
; GFX1030-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX1030-NEXT:  ; %bb.2: ; %UnifiedReturnBlock
; GFX1030-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; GFX1030-NEXT:    s_setpc_b64 s[30:31]
entry:
  %bc = icmp sgt i32 %x, 16
  br i1 %bc, label %endif, label %if

if:
  %ret = shl i32 %x, 2
  ret i32 %ret

endif:
  ret i32 %x
}

define i32 @test_insert_vcmpx_pattern_eq(i32 %x) {
; GFX1010-LABEL: test_insert_vcmpx_pattern_eq:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-NEXT:    v_cmp_ne_u32_e32 vcc_lo, 16, v0
; GFX1010-NEXT:    s_and_saveexec_b32 s4, vcc_lo
; GFX1010-NEXT:  ; %bb.1: ; %if
; GFX1010-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX1010-NEXT:  ; %bb.2: ; %UnifiedReturnBlock
; GFX1010-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; GFX1010-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1030-LABEL: test_insert_vcmpx_pattern_eq:
; GFX1030:       ; %bb.0: ; %entry
; GFX1030-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1030-NEXT:    s_mov_b32 s4, exec_lo
; GFX1030-NEXT:    v_cmpx_ne_u32_e32 16, v0
; GFX1030-NEXT:  ; %bb.1: ; %if
; GFX1030-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX1030-NEXT:  ; %bb.2: ; %UnifiedReturnBlock
; GFX1030-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; GFX1030-NEXT:    s_setpc_b64 s[30:31]
entry:
  %bc = icmp eq i32 %x, 16
  br i1 %bc, label %endif, label %if

if:
  %ret = shl i32 %x, 2
  ret i32 %ret

endif:
  ret i32 %x
}

define i32 @test_insert_vcmpx_pattern_ne(i32 %x) {
; GFX1010-LABEL: test_insert_vcmpx_pattern_ne:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-NEXT:    v_cmp_eq_u32_e32 vcc_lo, 16, v0
; GFX1010-NEXT:    s_and_saveexec_b32 s4, vcc_lo
; GFX1010-NEXT:  ; %bb.1: ; %if
; GFX1010-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX1010-NEXT:  ; %bb.2: ; %UnifiedReturnBlock
; GFX1010-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; GFX1010-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1030-LABEL: test_insert_vcmpx_pattern_ne:
; GFX1030:       ; %bb.0: ; %entry
; GFX1030-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1030-NEXT:    s_mov_b32 s4, exec_lo
; GFX1030-NEXT:    v_cmpx_eq_u32_e32 16, v0
; GFX1030-NEXT:  ; %bb.1: ; %if
; GFX1030-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX1030-NEXT:  ; %bb.2: ; %UnifiedReturnBlock
; GFX1030-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; GFX1030-NEXT:    s_setpc_b64 s[30:31]
entry:
  %bc = icmp ne i32 %x, 16
  br i1 %bc, label %endif, label %if

if:
  %ret = shl i32 %x, 2
  ret i32 %ret

endif:
  ret i32 %x
}

define i32 @test_insert_vcmpx_pattern_le(i32 %x) {
; GFX1010-LABEL: test_insert_vcmpx_pattern_le:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-NEXT:    v_cmp_lt_i32_e32 vcc_lo, 16, v0
; GFX1010-NEXT:    s_and_saveexec_b32 s4, vcc_lo
; GFX1010-NEXT:  ; %bb.1: ; %if
; GFX1010-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX1010-NEXT:  ; %bb.2: ; %UnifiedReturnBlock
; GFX1010-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; GFX1010-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1030-LABEL: test_insert_vcmpx_pattern_le:
; GFX1030:       ; %bb.0: ; %entry
; GFX1030-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1030-NEXT:    s_mov_b32 s4, exec_lo
; GFX1030-NEXT:    v_cmpx_lt_i32_e32 16, v0
; GFX1030-NEXT:  ; %bb.1: ; %if
; GFX1030-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX1030-NEXT:  ; %bb.2: ; %UnifiedReturnBlock
; GFX1030-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; GFX1030-NEXT:    s_setpc_b64 s[30:31]
entry:
  %bc = icmp sle i32 %x, 16
  br i1 %bc, label %endif, label %if

if:
  %ret = shl i32 %x, 2
  ret i32 %ret

endif:
  ret i32 %x
}

define i32 @test_insert_vcmpx_pattern_ge(i32 %x) {
; GFX1010-LABEL: test_insert_vcmpx_pattern_ge:
; GFX1010:       ; %bb.0: ; %entry
; GFX1010-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1010-NEXT:    v_cmp_gt_i32_e32 vcc_lo, 16, v0
; GFX1010-NEXT:    s_and_saveexec_b32 s4, vcc_lo
; GFX1010-NEXT:  ; %bb.1: ; %if
; GFX1010-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX1010-NEXT:  ; %bb.2: ; %UnifiedReturnBlock
; GFX1010-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; GFX1010-NEXT:    s_setpc_b64 s[30:31]
;
; GFX1030-LABEL: test_insert_vcmpx_pattern_ge:
; GFX1030:       ; %bb.0: ; %entry
; GFX1030-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX1030-NEXT:    s_mov_b32 s4, exec_lo
; GFX1030-NEXT:    v_cmpx_gt_i32_e32 16, v0
; GFX1030-NEXT:  ; %bb.1: ; %if
; GFX1030-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX1030-NEXT:  ; %bb.2: ; %UnifiedReturnBlock
; GFX1030-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; GFX1030-NEXT:    s_setpc_b64 s[30:31]
entry:
  %bc = icmp sge i32 %x, 16
  br i1 %bc, label %endif, label %if

if:
  %ret = shl i32 %x, 2
  ret i32 %ret

endif:
  ret i32 %x
}

declare amdgpu_gfx void @check_live_outs_helper(i64) #0

; In cases where the output operand cannot be safely removed,
; don't apply the v_cmpx transformation.
define amdgpu_cs void @check_live_outs(i32 %a, i32 %b) {
; GCN-LABEL: check_live_outs:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s8, SCRATCH_RSRC_DWORD0
; GCN-NEXT:    s_mov_b32 s9, SCRATCH_RSRC_DWORD1
; GCN-NEXT:    s_mov_b32 s10, -1
; GCN-NEXT:    s_mov_b32 s11, 0x31c16000
; GCN-NEXT:    s_add_u32 s8, s8, s0
; GCN-NEXT:    v_cmp_eq_u32_e64 s0, v0, v1
; GCN-NEXT:    s_addc_u32 s9, s9, 0
; GCN-NEXT:    s_mov_b32 s32, 0
; GCN-NEXT:    s_and_saveexec_b32 s1, s0
; GCN-NEXT:    s_cbranch_execz .LBB6_2
; GCN-NEXT:  ; %bb.1: ; %l1
; GCN-NEXT:    s_getpc_b64 s[2:3]
; GCN-NEXT:    s_add_u32 s2, s2, check_live_outs_helper@gotpcrel32@lo+4
; GCN-NEXT:    s_addc_u32 s3, s3, check_live_outs_helper@gotpcrel32@hi+12
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    s_load_dwordx2 s[4:5], s[2:3], 0x0
; GCN-NEXT:    v_mov_b32_e32 v1, 0
; GCN-NEXT:    s_mov_b64 s[0:1], s[8:9]
; GCN-NEXT:    s_mov_b64 s[2:3], s[10:11]
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; GCN-NEXT:  .LBB6_2: ; %l2
; GCN-NEXT:    s_endpgm
  %cond = icmp eq i32 %a, %b
  %result = call i64 @llvm.amdgcn.icmp.i32(i32 %a, i32 %b, i32 32)
  br i1 %cond, label %l1, label %l2
l1:
  call amdgpu_gfx void @check_live_outs_helper(i64 %result)
  br label %l2
l2:
  ret void
}

; Omit the transformation if the s_and_saveexec instruction overwrites
; any of the v_cmp source operands.
define i32 @check_saveexec_overwrites_vcmp_source(i32 inreg %a, i32 inreg %b) {
; GCN-LABEL: check_saveexec_overwrites_vcmp_source:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_cmp_lt_i32 s16, 0
; GCN-NEXT:    s_cbranch_scc1 .LBB7_2
; GCN-NEXT:  ; %bb.1: ; %if
; GCN-NEXT:    s_lshl_b32 s4, s16, 2
; GCN-NEXT:    s_or_b32 s4, s4, s17
; GCN-NEXT:    v_mov_b32_e32 v0, s4
; GCN-NEXT:    s_setpc_b64 s[30:31]
; GCN-NEXT:  .LBB7_2: ; %then
; GCN-NEXT:    v_cmp_eq_u32_e64 s4, s16, s17
; GCN-NEXT:    s_cmp_ge_i32 s4, s17
; GCN-NEXT:    s_cbranch_scc1 .LBB7_4
; GCN-NEXT:  ; %bb.3: ; %after
; GCN-NEXT:    v_mov_b32_e32 v0, s4
; GCN-NEXT:    s_setpc_b64 s[30:31]
; GCN-NEXT:  .LBB7_4: ; %end
; GCN-NEXT:    v_mov_b32_e32 v0, s16
; GCN-NEXT:    s_setpc_b64 s[30:31]
entry:
  %0 = icmp sge i32 %a, 0
  br i1 %0, label %if, label %then

if:
  %1 = shl i32 %a, 2
  %2 = or i32 %1, %b
  ret i32 %2

then:
  %3 = call i64 @llvm.amdgcn.icmp.i32(i32 %a, i32 %b, i32 32)
  %4 = trunc i64 %3 to i32
  %5 = icmp slt i32 %4, %b
  br i1 %5, label %after, label %end

after:
  ret i32 %4

end:
  ret i32 %a
}

declare i64 @llvm.amdgcn.icmp.i32(i32, i32, i32) #0
