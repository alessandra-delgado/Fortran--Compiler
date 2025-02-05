	.text
	.globl	main
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
	pushq $1
	popq %rax
	movq %rax, 0(%rbp)
	movq 0(%rbp), %rax
	pushq %rax
	popq %rdi
	call println_int
	movq 0(%rbp), %rax
	incq %rax
	movq %rax, 0(%rbp)
	movq 0(%rbp), %rax
	pushq %rax
	popq %rdi
	call println_int
	movq 0(%rbp), %rax
	incq %rax
	movq %rax, 0(%rbp)
	movq 0(%rbp), %rax
	pushq %rax
	popq %rdi
	call println_int
	movq 0(%rbp), %rax
	decq %rax
	movq %rax, 0(%rbp)
	movq 0(%rbp), %rax
	decq %rax
	movq %rax, 0(%rbp)
	movq 0(%rbp), %rax
	decq %rax
	movq %rax, 0(%rbp)
	movq 0(%rbp), %rax
	decq %rax
	movq %rax, 0(%rbp)
	movq 0(%rbp), %rax
	decq %rax
	movq %rax, 0(%rbp)
	movq 0(%rbp), %rax
	pushq %rax
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
read_int:
	pushq %rbp
	leaq .Sprint_int, %rdi
	movq $0, %rax
	call scanf
	popq %rbp
	ret
	.data
.Sprintln_int:
	.string "%ld\n"
.Sprint_int:
	.string "%ld"
