	.text
	.globl	main
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
	pushq $0
	popq %rax
	movq %rax, x
	pushq x
	popq %rdi
	call println_int
	leaq x, %rsi
	call read_int
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
read_int:
	pushq %rbp
	leaq .Sprint_int, %rdi
	movq $0, %rax
	call scanf
	popq %rbp
	ret
	.data
x:
	.quad 1
.Sprintln_int:
	.string "%d\n"
.Sprint_int:
	.string "%d"
