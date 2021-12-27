// See LICENSE for license details.

#include "mtrap.h"
#include "bits.h"
#include "config.h"
#include "defs.h"


  .data
  .align 6
trap_table:
#define BAD_TRAP_VECTOR 0
  .dc.a bad_trap
  .dc.a pmp_trap
  .dc.a illegal_insn_trap
  .dc.a bad_trap
  .dc.a misaligned_load_trap
  .dc.a pmp_trap
  .dc.a misaligned_store_trap
  .dc.a pmp_trap
  .dc.a bad_trap
  .dc.a mcall_trap
  .dc.a bad_trap
#ifdef BBL_BOOT_MACHINE
  .dc.a mcall_trap
#else
  .dc.a bad_trap
#endif /* BBL_BOOT_MACHINE */
  .dc.a bad_trap
#define TRAP_FROM_MACHINE_MODE_VECTOR 13
  .dc.a __trap_from_machine_mode
  .dc.a bad_trap
  .dc.a bad_trap

  .option norvc
  .section .text.init,"ax",@progbits

  .globl reset_vector
reset_vector:
  j do_reset

trap_vector:
  csrw mcapctl, x0 # Disable Capability checks

  csrrw sp, mscratch, sp
  beqz sp, .Ltrap_from_machine_mode

  STORE a0, 10*REGBYTES(sp)
  STORE a1, 11*REGBYTES(sp)

  csrr a1, mcause


  li a0, CAUSE_TEE_COMPARTMENT_EXCEPTION
  beq a0, a1, CHECKCAP_EXCEPTION

  bgez a1, .Lhandle_trap_in_machine_mode

  # This is an interrupt.  Discard the mcause MSB and decode the rest.
  sll a1, a1, 1

  # Is it a machine timer interrupt?
  li a0, IRQ_M_TIMER * 2
  bne a0, a1, 1f

  # Yes.  Simply clear MTIE and raise STIP.
  li a0, MIP_MTIP
  csrc mie, a0
  li a0, MIP_STIP
  csrs mip, a0

.Lmret:
  # Go back whence we came.
  li a0, 0x1
  csrw mcapctl, a0 # Enable Capability checks
  LOAD a0, 10*REGBYTES(sp)
  LOAD a1, 11*REGBYTES(sp)
  csrrw sp, mscratch, sp
  mret

1:
  # Is it an IPI?
  li a0, IRQ_M_SOFT * 2
  bne a0, a1, .Lbad_trap

  # Yes.  First, clear the MIPI bit.
  LOAD a0, MENTRY_IPI_OFFSET(sp)
  sw x0, (a0)
  fence

  # Now, decode the cause(s).
#ifdef __riscv_atomic
  addi a0, sp, MENTRY_IPI_PENDING_OFFSET
  amoswap.w a0, x0, (a0)
#else
  lw a0, MENTRY_IPI_PENDING_OFFSET(sp)
  sw x0, MENTRY_IPI_PENDING_OFFSET(sp)
#endif
  and a1, a0, IPI_SOFT
  beqz a1, 1f
  csrs mip, MIP_SSIP
1:
  andi a1, a0, IPI_FENCE_I
  beqz a1, 1f
  fence.i
1:
  andi a1, a0, IPI_SFENCE_VMA
  beqz a1, 1f
  sfence.vma
1:
  andi a1, a0, IPI_HALT
  beqz a1, 1f
  wfi
  j 1b
1:
  j .Lmret


.Lhandle_trap_in_machine_mode:
  # Preserve the registers.  Compute the address of the trap handler.
  STORE ra, 1*REGBYTES(sp)
  STORE gp, 3*REGBYTES(sp)
  STORE tp, 4*REGBYTES(sp)
  STORE t0, 5*REGBYTES(sp)
1:auipc t0, %pcrel_hi(trap_table)  # t0 <- %hi(trap_table)
  STORE t1, 6*REGBYTES(sp)
  sll t1, a1, LOG_REGBYTES         # t1 <- mcause * ptr size
  STORE t2, 7*REGBYTES(sp)
  add t1, t0, t1                   # t1 <- %hi(trap_table)[mcause]
  STORE s0, 8*REGBYTES(sp)
  LOAD t1, %pcrel_lo(1b)(t1)       # t1 <- trap_table[mcause]
  STORE s1, 9*REGBYTES(sp)
  mv a0, sp                        # a0 <- regs
  STORE a2,12*REGBYTES(sp)
  csrr a2, mepc                    # a2 <- mepc
  STORE a3,13*REGBYTES(sp)
  csrrw t0, mscratch, x0           # t0 <- user sp
  STORE a4,14*REGBYTES(sp)
  STORE a5,15*REGBYTES(sp)
  STORE a6,16*REGBYTES(sp)
  STORE a7,17*REGBYTES(sp)
  STORE s2,18*REGBYTES(sp)
  STORE s3,19*REGBYTES(sp)
  STORE s4,20*REGBYTES(sp)
  STORE s5,21*REGBYTES(sp)
  STORE s6,22*REGBYTES(sp)
  STORE s7,23*REGBYTES(sp)
  STORE s8,24*REGBYTES(sp)
  STORE s9,25*REGBYTES(sp)
  STORE s10,26*REGBYTES(sp)
  STORE s11,27*REGBYTES(sp)
  STORE t3,28*REGBYTES(sp)
  STORE t4,29*REGBYTES(sp)
  STORE t5,30*REGBYTES(sp)
  STORE t6,31*REGBYTES(sp)
  STORE t0, 2*REGBYTES(sp)         # sp

#ifndef __riscv_flen
  lw tp, (sp) # Move the emulated FCSR from x0's save slot into tp.
#endif
  STORE x0, (sp) # Zero x0's save slot.

  # Invoke the handler.
  jalr t1

#ifndef __riscv_flen
  sw tp, (sp) # Move the emulated FCSR from tp into x0's save slot.
#endif

restore_mscratch:
  # Restore mscratch, so future traps will know they didn't come from M-mode.
  csrw mscratch, sp

restore_regs:
  li a0, 0x1
  csrw mcapctl, a0 # Enable Capability checks
  # Restore all of the registers.
  LOAD ra, 1*REGBYTES(sp)
  LOAD gp, 3*REGBYTES(sp)
  LOAD tp, 4*REGBYTES(sp)
  LOAD t0, 5*REGBYTES(sp)
  LOAD t1, 6*REGBYTES(sp)
  LOAD t2, 7*REGBYTES(sp)
  LOAD s0, 8*REGBYTES(sp)
  LOAD s1, 9*REGBYTES(sp)
  LOAD a0,10*REGBYTES(sp)
  LOAD a1,11*REGBYTES(sp)
  LOAD a2,12*REGBYTES(sp)
  LOAD a3,13*REGBYTES(sp)
  LOAD a4,14*REGBYTES(sp)
  LOAD a5,15*REGBYTES(sp)
  LOAD a6,16*REGBYTES(sp)
  LOAD a7,17*REGBYTES(sp)
  LOAD s2,18*REGBYTES(sp)
  LOAD s3,19*REGBYTES(sp)
  LOAD s4,20*REGBYTES(sp)
  LOAD s5,21*REGBYTES(sp)
  LOAD s6,22*REGBYTES(sp)
  LOAD s7,23*REGBYTES(sp)
  LOAD s8,24*REGBYTES(sp)
  LOAD s9,25*REGBYTES(sp)
  LOAD s10,26*REGBYTES(sp)
  LOAD s11,27*REGBYTES(sp)
  LOAD t3,28*REGBYTES(sp)
  LOAD t4,29*REGBYTES(sp)
  LOAD t5,30*REGBYTES(sp)
  LOAD t6,31*REGBYTES(sp)
  LOAD sp, 2*REGBYTES(sp)
  mret

.Ltrap_from_machine_mode:
  csrr sp, mscratch
  addi sp, sp, -INTEGER_CONTEXT_SIZE
  STORE a0,10*REGBYTES(sp)
  STORE a1,11*REGBYTES(sp)
  li a1, TRAP_FROM_MACHINE_MODE_VECTOR
  j .Lhandle_trap_in_machine_mode

.Lbad_trap:
  li a1, BAD_TRAP_VECTOR
  j .Lhandle_trap_in_machine_mode

  .globl __redirect_trap
__redirect_trap:
  # reset sp to top of M-mode stack
  li t0, MACHINE_STACK_SIZE
  add sp, sp, t0
  neg t0, t0
  and sp, sp, t0
  addi sp, sp, -MENTRY_FRAME_SIZE
  j restore_mscratch

__trap_from_machine_mode:
  jal trap_from_machine_mode
  j restore_regs

do_reset:

  # Enable Capability control
  li t0, ENABLE_CAP # ENABLE_CAP is 0x1 for now
  # Initial compartment i.e. starting compartment
  li t1, INITIAL_COMPARTMENT
  # Load cap_matrix_base 
  la t2, cap_matrix
  # Load checkcap_sp to save/restore registers etc...
  la t3, checkcap_stack + CHECKCAP_STACK_SIZE
  # Disable no_cross_comp initially. Always fist compartment should not be 255/254
  li t4, 0x0

  # set corresponding CSRs
  csrw mcapctl, t0
  csrw ucurrcap, t1
  csrw mcapmatrixbase, t2
  csrw ucheckcapsp, t3
  csrw unocrosscomp, t4
  
  li x1, 0
  li x2, 0
  li x3, 0
  li x4, 0
  li x5, 0
  li x6, 0
  li x7, 0
  li x8, 0
  li x9, 0
// save a0 and a1; arguments from previous boot loader stage:
//  li x10, 0
//  li x11, 0
  li x12, 0
  li x13, 0
  li x14, 0
  li x15, 0
  li x16, 0
  li x17, 0
  li x18, 0
  li x19, 0
  li x20, 0
  li x21, 0
  li x22, 0
  li x23, 0
  li x24, 0
  li x25, 0
  li x26, 0
  li x27, 0
  li x28, 0
  li x29, 0
  li x30, 0
  li x31, 0
  csrw mscratch, x0

  # write mtvec and make sure it sticks
  la t0, trap_vector
  csrw mtvec, t0
  csrr t1, mtvec
1:bne t0, t1, 1b

  la sp, stacks + RISCV_PGSIZE - MENTRY_FRAME_SIZE

  csrr a3, mhartid
  slli a2, a3, RISCV_PGSHIFT
  add sp, sp, a2

  bnez a3, .LmultiHartInit

#ifdef ZERO_BSS
  # Zero out BSS; linker script provides alignment and padding
  la t0, _fbss
  la t1, _end
  beq t0, t1, 2f
1:STORE zero, 0(t0)
  addi t0, t0, REGBYTES
  bne t0, t1, 1b
2:
#endif

  # Boot on the first hart
#ifdef CUSTOM_DTS
  csrr a0, mhartid
  la a1, dtb_start
#endif
  j init_first_hart

.LmultiHartInit:
  # set MSIE bit to receive IPI
  li a2, MIP_MSIP
  csrw mie, a2

.LmultiHart:
#if MAX_HARTS > 1
  # wait for an IPI to signal that it's safe to boot
  wfi

  # masked harts never start
  la a4, disabled_hart_mask
  LOAD a4, 0(a4)
  srl a4, a4, a3
  andi a4, a4, 1
  bnez a4, .LmultiHart

  # only start if mip is set
  csrr a2, mip
  andi a2, a2, MIP_MSIP
  beqz a2, .LmultiHart

  # make sure our hart id is within a valid range
  fence
  li a2, MAX_HARTS
  bltu a3, a2, init_other_hart
#endif
  wfi
  j .LmultiHart


.global print_checkcap_cross_comp_matrix_fail
.global print_checkcap_no_cross_comp_fail

CHECKCAP_EXCEPTION:
  #Find out the exact cause of checkcap exception
  csrr t0, utargetcap
    csrr t1, unocrosscomp
    csrr t2, ucurrcap
    li t3, 1

    beq t0, t3, CHECKCAP_254

    beq t0, t2, CHECKCAP_NON_254
    
    li t4, 1
    beq t1, t4, CHECKCAP_NO_CROSS_COMP_FAIL

    j CHECKCAP_CROSS_COMP


CHECKCAP_254:
    #Step 1: Check if it is a tail-call, if yes skip saving the return registers on the checkcap-stack and changing the return-address
    csrr t0, uret254
    beq ra, t0, COMMON_254
    csrr t0, uretnon254
    beq ra, t0, COMMON_254
    csrr t0, uretcrosscomp
    beq ra, t0, COMMON_254
    
    #Step 2: Read CSR_UCHECKCAPSP
    csrr t2, ucheckcapsp

    #Step 3: Storing ra register

    addi t2, t2, -1*8
    sd ra, 0*8(t2)

    # update CSR_UCHECKCAPSP
    csrw ucheckcapsp, t2

    #Step 4: setting the ra to point to CHECKCAP_254_RETURN
    csrr ra, uret254

COMMON_254:
    #Step 5: Enabling the CSR_UNOCROSSCOMP
    li t2, 0x1
    csrw unocrosscomp, t2

    #Step 6: Zero out the register t2
    li t0, 0
    li t1, 0
    li t2, 0
    li t3, 0
    li t4, 0
    li t5, 0
    li t6, 0

    #Step 7: Call target function again
    j .Lmret

CHECKCAP_NON_254:
    #Step 2: Check if it is a tail-call, if yes skip saving the return registers on the checkcap-stack and changing the return-address
    csrr t0, uret254
    beq ra, t0, COMMON_254
    csrr t0, uretnon254
    beq ra, t0, COMMON_254
    csrr t0, uretcrosscomp
    beq ra, t0, COMMON_254

    #Step 2: Read CSR_UCHECKCAPSP
    csrr t2, ucheckcapsp

    #Step 3: Storing ra register
    addi t2, t2, -1*8
    sd ra, 0*8(t2)

    # update CSR_UCHECKCAPSP
    csrw ucheckcapsp, t2

    #Step 4: setting the ra to point to CHECKCAP_254_RETURN
    csrr ra, uretnon254

COMMON_NON_254:    
    # Step 5: Zero out the register t2
    li t0, 0
    li t1, 0
    li t2, 0
    li t3, 0
    li t4, 0
    li t5, 0
    li t6, 0

    #Step 6: Disabling the CSR_UNOCROSSCOMP
    csrw unocrosscomp, t2

    #Step 7: Call target function again
    j .Lmret

CHECKCAP_CROSS_COMP:
    #Step 1: Check if it is a tail-call, if yes skip saving the return registers on the checkcap-stack and changing the return-address
    # la t0, CHECKCAP_254_RETURN
    # beq ra, t0, COMMON_CROSS_COMP
    # la t0, CHECKCAP_NON_254_RETURN
    # beq ra, t0, COMMON_CROSS_COMP
    csrr t0, uretcrosscomp
    beq ra, t0, COMMON_254

    #Step 2: Read CSR_UCHECKCAPSP
    csrr t2, ucheckcapsp

    #Step 3: Storing curr_cap, ra, sp, gp, tp register

    addi t2, t2, -5*8

    # actual t0 stored in mscratch is saved later (neglect this comment for now, because no need to save/restore temporary registers as they are caller-saved)
    sd ra, 1*8(t2)
    sd sp, 2*8(t2)
    sd gp, 3*8(t2)
    sd tp, 4*8(t2)

    csrr t3, ucurrcap

    #store CURRCAP
    sd t3, 0*8(t2)

    # update CSR_UCHECKCAPSP
    csrw ucheckcapsp, t2

    #Step 4: setting the ra to point to CHECKCAP_CROSS_COMP_RETURN
    csrr ra, uretcrosscomp

    ##### Not doing this check for now
    #Step 5: Checking whether CSR_UCHECKCAPSP is within CSR_UCHECKCAPSPBASE and CSR_UCHECKCAPSPBOUND
    # (lower addr) Bound ---- SP ---- (higher addr) Base
    # csrr t1, ucheckcapspbase
    # csrr t2, ucheckcapspbound
    # blt t0, t1, Checkcap_SP_Out_Of_Bound
    # blt t1, t2, Checkcap_SP_Out_Of_Bound

COMMON_CROSS_COMP:
    #Step 6: Checking for cross-compartment Capability condition
    # ucurrcap
    # utargetcap
    # mcapmatrixbase
    ## access capability matrix. 
    # Here I am assuming that the capability matrix base address is stored in CSR_BASE_CAP_MATRIX
    csrr t0, mcapmatrixbase
    # Current Capability and Target Capability stored in CSRs CSR_UCURRCAP and CSR_UTARGETCAP respectively
    csrr t1, ucurrcap
    csrr t2, utargetcap
    # Assuming that the Capability matrix is stored as an array, where each compartment has its corresponding capability information in 256 bit entry.
    # Assuming each word is 64 bits, so the word that contains the target_cap info w.r.t curr_cap has to be loaded.
    # Accessing the capability matrix for a given curr_cap and target_cap is as follows:
    # SubStep 1: Finding the index(t3) corresponding to the target_cap and curr_cap: 
    # t3 = (t5)5*curr_cap + (t3){either of 0,1,2 or 3, depending on which group the target_cap lies, whether in 0-63, 64-127, 128-191, 192-255}*8(why 8 because
    # byte addressable). 
    addi t3, x0, 0 
    addi t4, x0, 0x40
    bltu t2, t4, Found_index
    addi t3, t3, 1
    addi t4, t4, 0x40
    bltu t2, t4, Found_index
    addi t3, t3, 1
    addi t4, t4, 0x40
    bltu t2, t4, Found_index
    addi t3, t3, 1
    addi t4, t4, 0x40
Found_index:
    sll t5, t1, 0x5 # t5= curr_cap * 32
    sll t3, t3, 0x3 # t3= word_offset wrt curr cap entry in table * 8
    add t5, t5, t3  # word offset wrt to start of table
    add t0, t0, t5  # word offset + base address of cap matrix
    ld t3, 0(t0)    # 64-bit entry of corresponding cap matrix
    # Getting the bit corresponding to the target_cap from the loaded word based on generating an appropriate mask w.r.t target_cap and &ing with the
    # loaded word  
    sub t4, t4, t2 # {256, 192, 128, 64} - target_cap. t4= {1-64}
    addi t4, t4, -0x1 # t4= {0-63} 
    # setting the MSB as 1 and rest 0's
    addi t5, x0, 0x1
    # setting bit w.r.t target_cap 1 and rest 0's
    slli t5, t5, 0x3f
    srl t5, t5, t4
    # anding t3 and t5(mask). If the output is 0 then check fail else, pass
    and t3, t3, t5
    beqz t3, CAPABILITY_CHECK_FAIL

    #Step 7: Change current_cap to target_cap
    csrw ucurrcap, t2

    #Step 8: zeroing out non-argument/return value registers. Not zeroing out sp, tp, gp, fp
    li t0, 0
    li t1, 0
    li t2, 0
    li t3, 0
    li t4, 0
    li t5, 0
    li t6, 0

    #Step 9: Call target function again
    j .Lmret


CAPABILITY_CHECK_FAIL:
    # If we follow the idea where we store the registers before the actual checking is done, then we need to remove them before we exit. And next, what 
    # should we do, poweroff!! ?
    csrw mcapctl, x0 # Disable Capability checks
    j print_checkcap_cross_comp_matrix_fail

CHECKCAP_NO_CROSS_COMP_FAIL:
    # Cross-Compartment jump attempted when CSR_UNOCROSSCOMP bit set
    csrw mcapctl, x0 # Disable Capability checks
    j print_checkcap_no_cross_comp_fail


#ifdef CUSTOM_DTS
.section .dtb
.align 3
.global dtb_start, dtb_end
dtb_start:
.incbin "custom.dtb"
dtb_end:
#endif

  .bss
  .align RISCV_PGSHIFT
stacks:
  .skip RISCV_PGSIZE * MAX_HARTS
