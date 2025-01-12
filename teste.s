	.text
	.globl	main
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	pushq $10
	popq %rax
	movq %rax, 0(%rbp)
	movq 0(%rbp), %rax
	pushq %rax
	pushq $20
	popq %rax
	movq %rax, 0(%rbp)
	pushq $30
	popq %rax
	movq %rax, -8(%rbp)
	movq 0(%rbp), %rax
	pushq %rax
	movq -8(%rbp), %rax
	pushq %rax
	popq %rax
	popq %rbx
	addq %rax, %rbx
	pushq %rbx
	popq %rax
	popq %rbx
	addq %rax, %rbx
	pushq %rbx
	popq %rdi
	call println_int
	pushq $100
	pushq $2
	movq $0, %rdx
	popq %rbx
	popq %rax
	idivq %rbx
	pushq %rax
	popq %rdi
	call println_int
	pushq $2
	pushq $100
	movq $0, %rdx
	popq %rbx
	popq %rax
	idivq %rbx
	pushq %rax
	popq %rdi
	call println_int
	pushq $10
	popq %rax
	movq %rax, x
	pushq x
	popq %rdi
	call println_int
	pushq x
	pushq x
	pushq $1
	popq %rax
	popq %rbx
	addq %rax, %rbx
	pushq %rbx
	popq %rax
	popq %rbx
	imulq %rax, %rbx
	pushq %rbx
	pushq $2
	movq $0, %rdx
	popq %rbx
	popq %rax
	idivq %rbx
	pushq %rax
	popq %rax
	movq %rax, y
	pushq y
	popq %rdi
	call println_int
	pushq $10
	popq %rax
	movq %rax, 0(%rbp)
	movq 0(%rbp), %rax
	pushq %rax
	pushq $20
	popq %rax
	movq %rax, 0(%rbp)
	pushq $30
	popq %rax
	movq %rax, -8(%rbp)
	movq 0(%rbp), %rax
	pushq %rax
	movq -8(%rbp), %rax
	pushq %rax
	popq %rax
	popq %rbx
	addq %rax, %rbx
	pushq %rbx
	popq %rax
	popq %rbx
	addq %rax, %rbx
	pushq %rbx
	popq %rdi
	call println_int
	pushq $20
	popq %rax
	movq %rax, x
	pushq x
	popq %rdi
	call println_int
	pushq x
	pushq $3
	popq %rax
	movq %rax, 0(%rbp)
	movq 0(%rbp), %rax
	pushq %rax
	popq %rax
	popq %rbx
	addq %rax, %rbx
	pushq %rbx
	pushq x
	popq %rax
	popq %rbx
	addq %rax, %rbx
	pushq %rbx
	popq %rax
	movq %rax, x
	pushq x
	popq %rdi
	call println_int
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
y:
	.quad 1
.Sprintln_int:
	.string "%d\n"
.Sprint_int:
	.string "%d"
