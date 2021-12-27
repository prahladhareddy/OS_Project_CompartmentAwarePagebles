	.file	"hello_world.c"
	.option nopic
	.attribute arch, "rv64i2p0_m2p0_a2p0_f2p0_d2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"ENTERING IS_SORTED"
	.align	3
.LC1:
	.string	"BAD EXITING IS_SORTED"
	.align	3
.LC2:
	.string	"EXITING IS_SORTED"
	.section	.text.is_sorted,"ax",@progbits
	.align	1
	.globl	is_sorted
	.type	is_sorted, @function
is_sorted:
	checkcap  1
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	sd	a0,-40(s0)
	mv	a5,a1
	sw	a5,-44(s0)
	lla	a0,.LC0
	call	puts
	sw	zero,-20(s0)
	j	.L2
.L5:
	lw	a5,-20(s0)
	slli	a5,a5,2
	ld	a4,-40(s0)
	add	a5,a4,a5
	lw	a3,0(a5)
	lw	a5,-20(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	ld	a4,-40(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	mv	a4,a3
	ble	a4,a5,.L3
	lla	a0,.LC1
	call	puts
	li	a5,0
	j	.L4
.L3:
	lw	a5,-20(s0)
	addiw	a5,a5,1
	sw	a5,-20(s0)
.L2:
	lw	a5,-44(s0)
	addiw	a5,a5,-1
	sext.w	a4,a5
	lw	a5,-20(s0)
	sext.w	a5,a5
	blt	a5,a4,.L5
	lla	a0,.LC2
	call	puts
	li	a5,1
.L4:
	mv	a0,a5
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	is_sorted, .-is_sorted
	.section	.rodata
	.align	3
.LC3:
	.string	"IN SORT"
	.align	3
.LC4:
	.string	"EXITING SORT"
	.section	.text.sort,"ax",@progbits
	.align	1
	.globl	sort
	.type	sort, @function
sort:
	checkcap  1
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	sd	a0,-40(s0)
	mv	a5,a1
	sw	a5,-44(s0)
	lla	a0,.LC3
	call	puts
	sw	zero,-20(s0)
	j	.L7
.L11:
	sw	zero,-24(s0)
	j	.L8
.L10:
	lw	a5,-24(s0)
	slli	a5,a5,2
	ld	a4,-40(s0)
	add	a5,a4,a5
	lw	a3,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	ld	a4,-40(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	mv	a4,a3
	ble	a4,a5,.L9
	lw	a5,-24(s0)
	slli	a5,a5,2
	ld	a4,-40(s0)
	add	a5,a4,a5
	lw	a5,0(a5)
	sw	a5,-28(s0)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	ld	a4,-40(s0)
	add	a4,a4,a5
	lw	a5,-24(s0)
	slli	a5,a5,2
	ld	a3,-40(s0)
	add	a5,a3,a5
	lw	a4,0(a4)
	sw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	ld	a4,-40(s0)
	add	a5,a4,a5
	lw	a4,-28(s0)
	sw	a4,0(a5)
.L9:
	lw	a5,-24(s0)
	addiw	a5,a5,1
	sw	a5,-24(s0)
.L8:
	lw	a5,-44(s0)
	addiw	a5,a5,-1
	sext.w	a4,a5
	lw	a5,-20(s0)
	subw	a5,a4,a5
	sext.w	a4,a5
	lw	a5,-24(s0)
	sext.w	a5,a5
	blt	a5,a4,.L10
	lw	a5,-20(s0)
	addiw	a5,a5,1
	sw	a5,-20(s0)
.L7:
	lw	a4,-20(s0)
	lw	a5,-44(s0)
	sext.w	a4,a4
	sext.w	a5,a5
	blt	a4,a5,.L11
	lla	a0,.LC4
	call	puts
	nop
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	sort, .-sort
	.section	.rodata
	.align	3
.LC5:
	.string	"IN MAIN"
	.align	3
.LC6:
	.string	"CORRECTLY SORTED"
	.align	3
.LC7:
	.string	"EXITING MAIN"
	.section	.text.main,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	checkcap  1
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	sd	s1,24(sp)
	addi	s0,sp,48
	call	init_comp_return
	lla	a0,.LC5
	call	puts
	li	a0,1
	call	my_alloc
	sd	a0,-48(s0)
	sw	zero,-36(s0)
	j	.L13
.L14:
	lw	a5,-36(s0)
	slli	a5,a5,2
	ld	a4,-48(s0)
	add	s1,a4,a5
	call	rand
	mv	a5,a0
	sw	a5,0(s1)
	lw	a5,-36(s0)
	addiw	a5,a5,1
	sw	a5,-36(s0)
.L13:
	lw	a5,-36(s0)
	sext.w	a4,a5
	li	a5,999
	ble	a4,a5,.L14
	li	a1,1000
	ld	a0,-48(s0)
	call	sort
	li	a1,1000
	ld	a0,-48(s0)
	call	is_sorted
	mv	a5,a0
	beq	a5,zero,.L15
	lla	a0,.LC6
	call	puts
.L15:
	lla	a0,.LC7
	call	puts
	nop
	ld	ra,40(sp)
	ld	s0,32(sp)
	ld	s1,24(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 9.2.0"
