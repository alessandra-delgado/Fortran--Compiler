	.text
	.globl	main
main:
	pushq %rbp
	movq %rsp, %rbp
	subq $32, %rsp
	pushq $6
	popq %rax
	movq %rax, 0(%rbp)
	movq 0(%rbp), %rax
	pushq %rax
	popq %rdi
	call println_int
	pushq $8
	popq %rax
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	pushq %rax
	popq %rdi
	call println_int
.do_begin1:
	movq -8(%rbp), %rax
	pushq %rax
	pushq $5
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setg %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .do_exit1
	movq -8(%rbp), %rax
	pushq %rax
	pushq $1
	popq %rax
	popq %rbx
	subq %rax, %rbx
	pushq %rbx
	popq %rax
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	pushq %rax
	popq %rdi
	call println_int
	jmp .do_begin1
.do_exit1:
	pushq $8
	popq %rax
	movq %rax, -8(%rbp)
.do_begin2:
	movq -8(%rbp), %rax
	pushq %rax
	pushq $1
	popq %rax
	popq %rbx
	subq %rax, %rbx
	pushq %rbx
	popq %rax
	movq %rax, -8(%rbp)
	movq -8(%rbp), %rax
	pushq %rax
	popq %rdi
	call println_int
	pushq $7
	popq %rax
	movq %rax, -16(%rbp)
	movq -16(%rbp), %rax
	pushq %rax
	popq %rdi
	call println_int
	movq -8(%rbp), %rax
	pushq %rax
	pushq $5
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setg %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	jne .do_begin2
.do_exit2:
	movq 0(%rbp), %rax
	pushq %rax
	popq %rdi
	call println_int
	movq -8(%rbp), %rax
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
