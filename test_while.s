	.text
	.globl	main
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $0, %rsp
	pushq $11111111
	popq %rdi
	call println_int
	pushq $0
	popq %rax
	movq %rax, x
.do_begin1:
	pushq x
	pushq $7
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setl %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .do_exit1
	pushq x
	pushq $1
	popq %rax
	popq %rbx
	addq %rax, %rbx
	pushq %rbx
	popq %rax
	movq %rax, x
	pushq x
	popq %rdi
	call println_int
	jmp .do_begin1
.do_exit1:
	pushq $0
	popq %rax
	movq %rax, x
.do_begin2:
	pushq x
	pushq $7
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setl %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .do_exit2
	pushq x
	pushq $1
	popq %rax
	popq %rbx
	addq %rax, %rbx
	pushq %rbx
	popq %rax
	movq %rax, x
	pushq x
	popq %rdi
	call println_int
	jmp .do_begin2
.do_exit2:
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
