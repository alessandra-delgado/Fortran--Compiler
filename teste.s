	.text
	.globl	main
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
	pushq $0
	popq %rax
	cmpq $0, %rax
	je .if_end1
.if_true1:
	pushq $2
	popq %rdi
	call println_int
.if_end1:
	pushq $0
	popq %rax
	cmpq $0, %rax
	jne .if_true2
	pushq $3
	popq %rdi
	call println_int
	jmp .if_end2
.if_true2:
	pushq $2
	popq %rdi
	call println_int
.if_end2:
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
