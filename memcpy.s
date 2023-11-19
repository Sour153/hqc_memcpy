	.file	"memcpy.c"
	.text
	.globl	my_memcpy1
	.type	my_memcpy1, @function
my_memcpy1:
.LFB23:
	.cfi_startproc
	jmp	.L2
.L3:
	movzbl	(%rsi), %edx
	movb	%dl, (%rdi)
	leaq	1(%rsi), %rsi
	leaq	1(%rdi), %rdi
	movq	%rax, %rdx
.L2:
	leaq	-1(%rdx), %rax
	testq	%rdx, %rdx
	jne	.L3
	rep ret
	.cfi_endproc
.LFE23:
	.size	my_memcpy1, .-my_memcpy1
	.globl	my_memcpy11
	.type	my_memcpy11, @function
my_memcpy11:
.LFB24:
	.cfi_startproc
	movl	$0, %ecx
	jmp	.L5
.L6:
	movzbl	(%rsi,%rax), %r8d
	movb	%r8b, (%rdi,%rax)
	movzbl	1(%rsi,%rax), %r8d
	movb	%r8b, 1(%rdi,%rax)
	movzbl	2(%rsi,%rax), %r8d
	movb	%r8b, 2(%rdi,%rax)
	movzbl	3(%rsi,%rax), %r8d
	movb	%r8b, 3(%rdi,%rax)
	movzbl	4(%rsi,%rax), %r8d
	movb	%r8b, 4(%rdi,%rax)
	movzbl	5(%rsi,%rax), %r8d
	movb	%r8b, 5(%rdi,%rax)
	movzbl	6(%rsi,%rax), %r8d
	movb	%r8b, 6(%rdi,%rax)
	movzbl	7(%rsi,%rax), %r8d
	movb	%r8b, 7(%rdi,%rax)
	movzbl	8(%rsi,%rax), %r8d
	movb	%r8b, 8(%rdi,%rax)
	movzbl	9(%rsi,%rax), %r8d
	movb	%r8b, 9(%rdi,%rax)
	addl	$10, %ecx
.L5:
	movslq	%ecx, %rax
	cmpq	%rdx, %rax
	jb	.L6
	rep ret
	.cfi_endproc
.LFE24:
	.size	my_memcpy11, .-my_memcpy11
	.globl	my_memcpy2
	.type	my_memcpy2, @function
my_memcpy2:
.LFB25:
	.cfi_startproc
	movq	%rdx, %r8
	andq	$-8, %r8
	movq	%rdx, %r10
	shrq	$3, %r10
	movl	$0, %ecx
	jmp	.L8
.L9:
	movq	(%rsi,%rax,8), %r9
	movq	%r9, (%rdi,%rax,8)
	addq	$1, %rax
	movq	(%rsi,%rax,8), %r9
	movq	%r9, (%rdi,%rax,8)
	addl	$2, %ecx
.L8:
	movslq	%ecx, %rax
	cmpq	%r10, %rax
	jb	.L9
	cmpq	%rdx, %r8
	jnb	.L7
	movl	%r8d, %ecx
	jmp	.L11
.L12:
	movzbl	(%rsi,%rax), %r8d
	movb	%r8b, (%rdi,%rax)
	addl	$1, %ecx
.L11:
	movslq	%ecx, %rax
	cmpq	%rdx, %rax
	jb	.L12
.L7:
	rep ret
	.cfi_endproc
.LFE25:
	.size	my_memcpy2, .-my_memcpy2
	.globl	mysecond
	.type	mysecond, @function
mysecond:
.LFB28:
	.cfi_startproc
	subq	$56, %rsp
	.cfi_def_cfa_offset 64
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	leaq	8(%rsp), %rsi
	leaq	16(%rsp), %rdi
	call	gettimeofday@PLT
	pxor	%xmm0, %xmm0
	cvtsi2sdq	16(%rsp), %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2sdq	24(%rsp), %xmm1
	mulsd	.LC0(%rip), %xmm1
	addsd	%xmm1, %xmm0
	movq	40(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L16
	addq	$56, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L16:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE28:
	.size	mysecond, .-mysecond
	.globl	getGFlops
	.type	getGFlops, @function
getGFlops:
.LFB26:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$112, %rsp
	.cfi_def_cfa_offset 144
	movq	%rdi, %r12
	movq	%rsi, %rbp
	movq	%fs:40, %rax
	movq	%rax, 104(%rsp)
	xorl	%eax, %eax
	movq	$0, 16(%rsp)
	movq	$0, 24(%rsp)
	movq	$0, 32(%rsp)
	movq	$0, 40(%rsp)
	movq	$0, 48(%rsp)
	movq	$0, 56(%rsp)
	movq	$0, 64(%rsp)
	movq	$0, 72(%rsp)
	movq	$0, 80(%rsp)
	movq	$0, 88(%rsp)
	movl	$0, %ebx
	jmp	.L18
.L19:
	movl	$0, %eax
	call	mysecond
	movsd	%xmm0, 8(%rsp)
	movq	%rbp, %rdx
	leaq	b(%rip), %rsi
	leaq	a(%rip), %rdi
	call	*%r12
	movl	$0, %eax
	call	mysecond
	subsd	8(%rsp), %xmm0
	movslq	%ebx, %rax
	movsd	%xmm0, 16(%rsp,%rax,8)
	addl	$1, %ebx
.L18:
	cmpl	$9, %ebx
	jle	.L19
	movl	$0, %eax
	pxor	%xmm0, %xmm0
	jmp	.L20
.L21:
	movslq	%eax, %rdx
	addsd	16(%rsp,%rdx,8), %xmm0
	addl	$1, %eax
.L20:
	cmpl	$9, %eax
	jle	.L21
	movapd	%xmm0, %xmm1
	divsd	.LC2(%rip), %xmm1
	testq	%rbp, %rbp
	js	.L22
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbp, %xmm0
.L23:
	addsd	%xmm0, %xmm0
	divsd	%xmm1, %xmm0
	movsd	.LC3(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	mulsd	%xmm1, %xmm0
	movq	104(%rsp), %rax
	xorq	%fs:40, %rax
	jne	.L26
	addq	$112, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L22:
	.cfi_restore_state
	movq	%rbp, %rax
	shrq	%rax
	andl	$1, %ebp
	orq	%rbp, %rax
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rax, %xmm0
	addsd	%xmm0, %xmm0
	jmp	.L23
.L26:
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE26:
	.size	getGFlops, .-getGFlops
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC4:
	.string	"byte_size       gflops1       gflops2"
	.align 8
.LC5:
	.string	"%9.6lfMB %16.6lfMB/s%16.6lfMB/s\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB27:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	leaq	.LC4(%rip), %rdi
	call	puts@PLT
	movl	$1000, %ebx
	jmp	.L28
.L29:
	movslq	%ebx, %rbp
	movq	%rbp, %rsi
	leaq	my_memcpy11(%rip), %rdi
	call	getGFlops
	movsd	%xmm0, 8(%rsp)
	movq	%rbp, %rsi
	leaq	my_memcpy1(%rip), %rdi
	call	getGFlops
	movapd	%xmm0, %xmm1
	pxor	%xmm2, %xmm2
	cvtsi2sd	%ebx, %xmm2
	movsd	.LC3(%rip), %xmm3
	mulsd	%xmm3, %xmm2
	movapd	%xmm2, %xmm4
	mulsd	%xmm3, %xmm4
	movapd	%xmm4, %xmm0
	movsd	8(%rsp), %xmm2
	leaq	.LC5(%rip), %rsi
	movl	$1, %edi
	movl	$3, %eax
	call	__printf_chk@PLT
	addl	$1000, %ebx
.L28:
	cmpl	$19999, %ebx
	jle	.L29
	movl	$0, %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE27:
	.size	main, .-main
	.local	b
	.comm	b,800000000,32
	.local	a
	.comm	a,800000000,32
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC0:
	.long	2696277389
	.long	1051772663
	.align 8
.LC2:
	.long	0
	.long	1076101120
	.align 8
.LC3:
	.long	0
	.long	1062207488
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
