	.file	"hello_world.c"
	.option nopic
	.attribute arch, "rv64i2p0_m2p0_a2p0_f2p0_d2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"ENTERING MAIN"
	.align	3
.LC1:
	.string	"STARTED TESTING FOR COMPARTMENT 0"
	.align	3
.LC2:
	.string	"a[11] = %d\n"
	.align	3
.LC3:
	.string	"COMPLEATED TESTING FOR COMPARTMENT 0"
	.align	3
.LC4:
	.string	"STARTED TESTING FOR COMPARTMENT 1"
	.align	3
.LC5:
	.string	"b[11] = %d\n"
	.align	3
.LC6:
	.string	"COMPLEATED TESTING FOR COMPARTMENT 1"
	.align	3
.LC7:
	.string	"STARTED TESTING FOR CMPARTMENT 5"
	.align	3
.LC8:
	.string	"COMPLEATED TESTING FOR COMPARTMENT 5"
	.align	3
.LC9:
	.string	"STARTED TESTING FOR COMPARTMENT 6"
	.align	3
.LC10:
	.string	"COMPLEATED TESTING FOR COMPARTMENT 6"
	.align	3
.LC11:
	.string	"EXITING MAIN"
	.section	.text.main,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	checkcap  5
	addi	sp,sp,-48
	sd	ra,40(sp)
	sd	s0,32(sp)
	addi	s0,sp,48
	lla	a0,.LC0
	call	puts
	call	init_comp_return
	lla	a0,.LC1
	call	puts
	li	a0,0
	call	my_alloc
	sd	a0,-24(s0)
	ld	a5,-24(s0)
	addi	a5,a5,176
	li	a4,100
	sw	a4,0(a5)
	ld	a5,-24(s0)
	addi	a5,a5,264
	li	a4,110
	sw	a4,0(a5)
	ld	a5,-24(s0)
	addi	a5,a5,176
	lw	a3,0(a5)
	ld	a5,-24(s0)
	addi	a5,a5,264
	lw	a4,0(a5)
	ld	a5,-24(s0)
	addi	a5,a5,44
	addw	a4,a3,a4
	sext.w	a4,a4
	sw	a4,0(a5)
	ld	a5,-24(s0)
	addi	a5,a5,44
	lw	a5,0(a5)
	mv	a1,a5
	lla	a0,.LC2
	call	printf
	lla	a0,.LC3
	call	puts
	lla	a0,.LC4
	call	puts
	li	a0,1
	call	my_alloc
	sd	a0,-32(s0)
	ld	a5,-32(s0)
	addi	a5,a5,176
	li	a4,100
	sw	a4,0(a5)
	ld	a5,-32(s0)
	addi	a5,a5,264
	li	a4,110
	sw	a4,0(a5)
	ld	a5,-32(s0)
	addi	a5,a5,176
	lw	a3,0(a5)
	ld	a5,-32(s0)
	addi	a5,a5,264
	lw	a4,0(a5)
	ld	a5,-32(s0)
	addi	a5,a5,44
	addw	a4,a3,a4
	sext.w	a4,a4
	sw	a4,0(a5)
	ld	a5,-32(s0)
	addi	a5,a5,44
	lw	a5,0(a5)
	mv	a1,a5
	lla	a0,.LC5
	call	printf
	lla	a0,.LC6
	call	puts
	lla	a0,.LC7
	call	puts
	li	a0,5
	call	my_alloc
	sd	a0,-40(s0)
	ld	a5,-40(s0)
	addi	a5,a5,176
	li	a4,100
	sw	a4,0(a5)
	ld	a5,-40(s0)
	addi	a5,a5,264
	li	a4,110
	sw	a4,0(a5)
	ld	a5,-40(s0)
	addi	a5,a5,176
	lw	a3,0(a5)
	ld	a5,-40(s0)
	addi	a5,a5,264
	lw	a4,0(a5)
	ld	a5,-40(s0)
	addi	a5,a5,44
	addw	a4,a3,a4
	sext.w	a4,a4
	sw	a4,0(a5)
	ld	a5,-40(s0)
	addi	a5,a5,44
	lw	a5,0(a5)
	mv	a1,a5
	lla	a0,.LC5
	call	printf
	lla	a0,.LC8
	call	puts
	lla	a0,.LC9
	call	puts
	li	a0,6
	call	my_alloc
	sd	a0,-48(s0)
	ld	a5,-48(s0)
	addi	a5,a5,176
	li	a4,100
	sw	a4,0(a5)
	ld	a5,-48(s0)
	addi	a5,a5,264
	li	a4,110
	sw	a4,0(a5)
	ld	a5,-48(s0)
	addi	a5,a5,176
	lw	a3,0(a5)
	ld	a5,-48(s0)
	addi	a5,a5,264
	lw	a4,0(a5)
	ld	a5,-48(s0)
	addi	a5,a5,44
	addw	a4,a3,a4
	sext.w	a4,a4
	sw	a4,0(a5)
	ld	a5,-48(s0)
	addi	a5,a5,44
	lw	a5,0(a5)
	mv	a1,a5
	lla	a0,.LC5
	call	printf
	lla	a0,.LC10
	call	puts
	lla	a0,.LC11
	call	puts
	nop
	ld	ra,40(sp)
	ld	s0,32(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 9.2.0"
