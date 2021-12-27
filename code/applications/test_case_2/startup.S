#define TEXT_SECTION(name) .section .text.##name,"ax",@progbits

#define FUNCTION(name) \
        TEXT_SECTION(name); \
        .align 2; \
        .globl name; \
        .type name, @function; \
name:

FUNCTION(init_comp_return)
    la t0, CHECKCAP_254_RETURN
    csrw uret254, t0
    la t0, CHECKCAP_NON_254_RETURN
    csrw uretnon254, t0
    la t0, CHECKCAP_CROSS_COMP_RETURN
    csrw uretcrosscomp, t0
    jr ra
    .size init_comp_return, .-init_comp_return

FUNCTION(CHECKCAP_254_RETURN)
    #Step 1: Read CSR_UCHECKCAPSP
    csrr t2, ucheckcapsp

    #Step 2: Popping the registers first itself
    ld ra, 0*8(t2)

    # update CSR_UCHECKCAPSP
    addi t2, t2, 1*8
    csrw ucheckcapsp, t2

    # Step 3: Zero out the register t2
    li t0, 0
    li t1, 0
    li t2, 0
    li t3, 0
    li t4, 0
    li t5, 0
    li t6, 0

    #Step 4: Disabling the CSR_UNOCROSSCOMP
    csrw unocrosscomp, t2

    #Step 5: Return to caller function
    jr ra
    .size   CHECKCAP_254_RETURN, .-CHECKCAP_254_RETURN

FUNCTION(CHECKCAP_NON_254_RETURN)
    #Step 1: Read CSR_UCHECKCAPSP
    csrr t2, ucheckcapsp

    #Step 2: Popping the registers first itself
    ld ra, 0*8(t2)

    # update CSR_UCHECKCAPSP
    addi t2, t2, 1*8
    csrw ucheckcapsp, t2

    #Step 3: Enabling the CSR_UNOCROSSCOMP
    li t2, 1
    csrw unocrosscomp, t2

    # Step 4: Zero out the register t2
    li t0, 0
    li t1, 0
    li t2, 0
    li t3, 0
    li t4, 0
    li t5, 0
    li t6, 0

    #Step 5: Return to caller function
    jr ra
    .size   CHECKCAP_NON_254_RETURN, .-CHECKCAP_NON_254_RETURN

FUNCTION(CHECKCAP_CROSS_COMP_RETURN)
    #Step 1: Read CSR_UCHECKCAPSP
    csrr t2, ucheckcapsp

    #Step 2: Popping the registers first itself

    # actual t0, t1 restored later (neglect this comment for now, because no need to save/restore temporary registers as they are caller-saved)
    ld ra, 1*8(t2)
    ld sp, 2*8(t2)
    ld gp, 3*8(t2)
    ld tp, 4*8(t2)
    
    # restore CSR_UCURRCAP
    ld t1, 0*8(t2)
    csrw ucurrcap, t1

    # update CSR_UCHECKCAPSP
    addi t2, t2, 5*8
    csrw ucheckcapsp, t2

    # Step 3: Zero out the t0-t6 registers 
    li t0, 0
    li t1, 0
    li t2, 0
    li t3, 0
    li t4, 0
    li t5, 0
    li t6, 0

    #Step 4: Disabling the CSR_UNOCROSSCOMP. This is done, 
    csrw unocrosscomp, t2

    #Step 5: Return to caller function
    jr ra
    .size   CHECKCAP_CROSS_COMP_RETURN, .-CHECKCAP_CROSS_COMP_RETURN

