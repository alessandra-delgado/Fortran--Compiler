	.text
	.globl	main
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
	pushq $1
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setg %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	jne .if_true1
	pushq $0
	popq %rdi
	call println_int
	jmp .if_end1
.if_true1:
	pushq $1
	popq %rdi
	call println_int
.if_end1:
	pushq $5
	popq %rax
	cmpq $0, %rax
	je .if_end2
.if_true2:
	pushq $9
	popq %rdi
	call println_int
	pushq $100
	popq %rdi
	call println_int
.if_end2:
	pushq $10
	popq %rax
	movq %rax, x
	pushq x
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setg %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .if_end3
.if_true3:
	pushq x
	pushq $10
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setne %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .if_end4
.if_true4:
	pushq x
	popq %rdi
	call println_int
.if_end4:
.if_end3:
	pushq x
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setne %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .if_end5
.if_true5:
	pushq $0
	popq %rax
	movq %rax, x
	pushq x
	pushq $1
	popq %rax
	popq %rbx
	addq %rax, %rbx
	pushq %rbx
	popq %rdi
	call println_int
	pushq x
	popq %rdi
	call println_int
	pushq $1
	popq %rax
	movq %rax, x
	pushq x
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	jne .if_true6
	pushq $404
	popq %rdi
	call println_int
	jmp .if_end6
.if_true6:
	pushq x
	popq %rdi
	call println_int
.if_end6:
.if_end5:
	movq $0, %rax
	movq %rbp, %rsp
	popq %rbp
	ret
println_int:
	pushq %rbp
	movq %rdi, %rsi
	leaq .Sprintln_int, %rdi
	movq $0, %rax
	call printf
	popq %rbp
	ret
print_int:
	pushq %rbp
	movq %rdi, %rsi
	leaq .Sprint_int, %rdi
	movq $0, %rax
	call printf
	popq %rbp
	ret
	.data
x:
	.quad 1
.Sprintln_int:
	.string "%d\n"
.Sprint_int:
	.string "%d"
