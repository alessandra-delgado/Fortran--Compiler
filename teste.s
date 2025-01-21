	.text
	.globl	main
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
	pushq $0
	popq %rax
	movq %rax, i
.do_begin1:
	pushq i
	pushq $10
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setl %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .do_exit1
	pushq i
	popq %rdi
	call println_int
	pushq i
	pushq $1
	popq %rax
	popq %rbx
	addq %rax, %rbx
	pushq %rbx
	popq %rax
	movq %rax, i
	jmp .do_begin1
.do_exit1:
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
i:
	.quad 1
.Sprintln_int:
	.string "%d\n"
.Sprint_int:
	.string "%d"
