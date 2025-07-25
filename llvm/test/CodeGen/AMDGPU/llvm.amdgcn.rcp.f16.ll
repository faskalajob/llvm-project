; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc -mtriple=amdgcn -mcpu=fiji -mattr=-flat-for-global < %s | FileCheck -check-prefix=GCN -check-prefix=VI %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx1100 -mattr=-flat-for-global,+real-true16 < %s | FileCheck -check-prefix=GFX11-TRUE16 %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx1100 -mattr=-flat-for-global,-real-true16 < %s | FileCheck -check-prefix=GFX11-FAKE16 %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx1200 -mattr=-flat-for-global,+real-true16 < %s | FileCheck -check-prefix=GFX12-TRUE16 %s
; RUN: llc -mtriple=amdgcn -mcpu=gfx1200 -mattr=-flat-for-global,-real-true16 < %s | FileCheck -check-prefix=GFX12-FAKE16 %s

declare half @llvm.amdgcn.rcp.f16(half %a)

define amdgpu_kernel void @rcp_f16(
; GCN-LABEL: rcp_f16:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x24
; GCN-NEXT:    s_mov_b32 s7, 0xf000
; GCN-NEXT:    s_mov_b32 s6, -1
; GCN-NEXT:    s_mov_b32 s10, s6
; GCN-NEXT:    s_mov_b32 s11, s7
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s8, s2
; GCN-NEXT:    s_mov_b32 s9, s3
; GCN-NEXT:    buffer_load_ushort v0, off, s[8:11], 0
; GCN-NEXT:    s_mov_b32 s4, s0
; GCN-NEXT:    s_mov_b32 s5, s1
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_rcp_f16_e32 v0, v0
; GCN-NEXT:    buffer_store_short v0, off, s[4:7], 0
; GCN-NEXT:    s_endpgm
;
; GFX11-TRUE16-LABEL: rcp_f16:
; GFX11-TRUE16:       ; %bb.0: ; %entry
; GFX11-TRUE16-NEXT:    s_load_b128 s[0:3], s[4:5], 0x24
; GFX11-TRUE16-NEXT:    s_mov_b32 s6, -1
; GFX11-TRUE16-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-TRUE16-NEXT:    s_mov_b32 s10, s6
; GFX11-TRUE16-NEXT:    s_mov_b32 s11, s7
; GFX11-TRUE16-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-TRUE16-NEXT:    s_mov_b32 s8, s2
; GFX11-TRUE16-NEXT:    s_mov_b32 s9, s3
; GFX11-TRUE16-NEXT:    s_mov_b32 s4, s0
; GFX11-TRUE16-NEXT:    buffer_load_u16 v0, off, s[8:11], 0
; GFX11-TRUE16-NEXT:    s_mov_b32 s5, s1
; GFX11-TRUE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-TRUE16-NEXT:    v_rcp_f16_e32 v0.l, v0.l
; GFX11-TRUE16-NEXT:    buffer_store_b16 v0, off, s[4:7], 0
; GFX11-TRUE16-NEXT:    s_endpgm
;
; GFX11-FAKE16-LABEL: rcp_f16:
; GFX11-FAKE16:       ; %bb.0: ; %entry
; GFX11-FAKE16-NEXT:    s_load_b128 s[0:3], s[4:5], 0x24
; GFX11-FAKE16-NEXT:    s_mov_b32 s6, -1
; GFX11-FAKE16-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-FAKE16-NEXT:    s_mov_b32 s10, s6
; GFX11-FAKE16-NEXT:    s_mov_b32 s11, s7
; GFX11-FAKE16-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-FAKE16-NEXT:    s_mov_b32 s8, s2
; GFX11-FAKE16-NEXT:    s_mov_b32 s9, s3
; GFX11-FAKE16-NEXT:    s_mov_b32 s4, s0
; GFX11-FAKE16-NEXT:    buffer_load_u16 v0, off, s[8:11], 0
; GFX11-FAKE16-NEXT:    s_mov_b32 s5, s1
; GFX11-FAKE16-NEXT:    s_waitcnt vmcnt(0)
; GFX11-FAKE16-NEXT:    v_rcp_f16_e32 v0, v0
; GFX11-FAKE16-NEXT:    buffer_store_b16 v0, off, s[4:7], 0
; GFX11-FAKE16-NEXT:    s_endpgm
;
; GFX12-TRUE16-LABEL: rcp_f16:
; GFX12-TRUE16:       ; %bb.0: ; %entry
; GFX12-TRUE16-NEXT:    s_load_b128 s[0:3], s[4:5], 0x24
; GFX12-TRUE16-NEXT:    s_mov_b32 s6, -1
; GFX12-TRUE16-NEXT:    s_mov_b32 s7, 0x31016000
; GFX12-TRUE16-NEXT:    s_mov_b32 s10, s6
; GFX12-TRUE16-NEXT:    s_mov_b32 s11, s7
; GFX12-TRUE16-NEXT:    s_wait_kmcnt 0x0
; GFX12-TRUE16-NEXT:    s_mov_b32 s8, s2
; GFX12-TRUE16-NEXT:    s_mov_b32 s9, s3
; GFX12-TRUE16-NEXT:    s_mov_b32 s4, s0
; GFX12-TRUE16-NEXT:    buffer_load_u16 v0, off, s[8:11], null
; GFX12-TRUE16-NEXT:    s_mov_b32 s5, s1
; GFX12-TRUE16-NEXT:    s_wait_loadcnt 0x0
; GFX12-TRUE16-NEXT:    v_rcp_f16_e32 v0.l, v0.l
; GFX12-TRUE16-NEXT:    buffer_store_b16 v0, off, s[4:7], null
; GFX12-TRUE16-NEXT:    s_endpgm
;
; GFX12-FAKE16-LABEL: rcp_f16:
; GFX12-FAKE16:       ; %bb.0: ; %entry
; GFX12-FAKE16-NEXT:    s_load_b128 s[0:3], s[4:5], 0x24
; GFX12-FAKE16-NEXT:    s_mov_b32 s6, -1
; GFX12-FAKE16-NEXT:    s_mov_b32 s7, 0x31016000
; GFX12-FAKE16-NEXT:    s_mov_b32 s10, s6
; GFX12-FAKE16-NEXT:    s_mov_b32 s11, s7
; GFX12-FAKE16-NEXT:    s_wait_kmcnt 0x0
; GFX12-FAKE16-NEXT:    s_mov_b32 s8, s2
; GFX12-FAKE16-NEXT:    s_mov_b32 s9, s3
; GFX12-FAKE16-NEXT:    s_mov_b32 s4, s0
; GFX12-FAKE16-NEXT:    buffer_load_u16 v0, off, s[8:11], null
; GFX12-FAKE16-NEXT:    s_mov_b32 s5, s1
; GFX12-FAKE16-NEXT:    s_wait_loadcnt 0x0
; GFX12-FAKE16-NEXT:    v_rcp_f16_e32 v0, v0
; GFX12-FAKE16-NEXT:    buffer_store_b16 v0, off, s[4:7], null
; GFX12-FAKE16-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a) {
entry:
  %a.val = load half, ptr addrspace(1) %a
  %r.val = call half @llvm.amdgcn.rcp.f16(half %a.val)
  store half %r.val, ptr addrspace(1) %r
  ret void
}
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; VI: {{.*}}
