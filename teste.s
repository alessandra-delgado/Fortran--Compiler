	.text
	.globl	main
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp
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
	pushq $1
	popq %rax
	movq %rax, 0(%rbp)
	movq 0(%rbp), %rax
	pushq %rax
	popq %rdi
	call println_int
	movq 0(%rbp), %rax
	pushq %rax
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .if_end3
.if_true3:
	pushq $2
	popq %rdi
	call println_int
.if_end3:
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
