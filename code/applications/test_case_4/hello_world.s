	.file	"hello_world.c"
	.option nopic
	.attribute arch, "rv64i2p0_m2p0_a2p0_f2p0_d2p0_c2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"INSIDE FOO"
	.align	3
.LC1:
	.string	"STARTED TESTING FOR COMPARTMRENT 0"
	.align	3
.LC2:
	.string	"%d\n"
	.align	3
.LC3:
	.string	"TESTING COMPLEATED FOR COMPARTMENT 0"
	.align	3
.LC4:
	.string	"STARTED TESTING FOR COMPARTMRENT 1"
	.align	3
.LC5:
	.string	"TESTING COMPLEATED FOR COMPARTMENT 1"
	.align	3
.LC6:
	.string	"STARTED TESTING FOR COMPARTMRENT 6"
	.align	3
.LC7:
	.string	"TESTING COMPLEATED FOR COMPARTMENT 6"
	.align	3
.LC8:
	.string	"STARTED TESTING FOR COMPARTMRENT 5"
	.align	3
.LC9:
	.string	"TESTING COMPLEATED FOR COMPARTMENT 5"
	.align	3
.LC10:
	.string	"Exiting FOO"
	.section	.text.foo,"ax",@progbits
	.align	1
	.globl	foo
	.type	foo, @function
foo:
	checkcap  6
	addi	sp,sp,-64
	sd	ra,56(sp)
	sd	s0,48(sp)
	addi	s0,sp,64
	sd	a0,-56(s0)
	lla	a0,.LC0
	call	puts
	lla	a0,.LC1
	call	puts
	ld	a5,-56(s0)
	addi	a5,a5,80
	li	a4,100
	sw	a4,0(a5)
	ld	a5,-56(s0)
	addi	a5,a5,80
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
	sd	a0,-24(s0)
	ld	a5,-24(s0)
	addi	a5,a5,80
	li	a4,150
	sw	a4,0(a5)
	ld	a5,-24(s0)
	addi	a5,a5,80
	lw	a5,0(a5)
	mv	a1,a5
	lla	a0,.LC2
	call	printf
	lla	a0,.LC5
	call	puts
	lla	a0,.LC6
	call	puts
	li	a0,6
	call	my_alloc
	sd	a0,-32(s0)
	ld	a5,-32(s0)
	addi	a5,a5,80
	li	a4,150
	sw	a4,0(a5)
	ld	a5,-32(s0)
	addi	a5,a5,80
	lw	a5,0(a5)
	mv	a1,a5
	lla	a0,.LC2
	call	printf
	lla	a0,.LC7
	call	puts
	lla	a0,.LC8
	call	puts
	li	a0,5
	call	my_alloc
	sd	a0,-40(s0)
	ld	a5,-40(s0)
	addi	a5,a5,80
	li	a4,150
	sw	a4,0(a5)
	ld	a5,-40(s0)
	addi	a5,a5,80
	lw	a5,0(a5)
	mv	a1,a5
	lla	a0,.LC2
	call	printf
	lla	a0,.LC9
	call	puts
	lla	a0,.LC10
	call	puts
	nop
	ld	ra,56(sp)
	ld	s0,48(sp)
	addi	sp,sp,64
	jr	ra
	.size	foo, .-foo
	.section	.rodata
	.align	3
.LC11:
	.string	"ENTERING MAIN"
	.align	3
.LC12:
	.string	"EXITING MAIN"
	.section	.text.main,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	checkcap  5
	addi	sp,sp,-32
	sd	ra,24(sp)
	sd	s0,16(sp)
	addi	s0,sp,32
	call	init_comp_return
	lla	a0,.LC11
	call	puts
	li	a0,0
	call	my_alloc
	sd	a0,-24(s0)
	ld	a0,-24(s0)
	call	foo
	lla	a0,.LC12
	call	puts
	nop
	ld	ra,24(sp)
	ld	s0,16(sp)
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.ident	"GCC: (GNU) 9.2.0"
