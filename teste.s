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
	pushq $1
	popq %rax
	movq %rax, x
	pushq $11111111
	popq %rdi
	call println_int
	pushq $1
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	jne .if_true7
	pushq $0
	popq %rdi
	call println_int
	jmp .if_end7
.if_true7:
	pushq $2
	popq %rdi
	call println_int
.if_end7:
	pushq $1
	pushq $1
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	jne .if_true8
	pushq $0
	popq %rdi
	call println_int
	jmp .if_end8
.if_true8:
	pushq $2
	popq %rdi
	call println_int
.if_end8:
	pushq $0
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	jne .bool_condition1
	pushq $0
	jmp .bool_end1
.bool_condition1:
	pushq $0
.bool_end1:
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	jne .if_true9
	pushq $0
	popq %rdi
	call println_int
	jmp .if_end9
.if_true9:
	pushq $2
	popq %rdi
	call println_int
.if_end9:
	pushq $1
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .bool_condition2
	pushq $1
	jmp .bool_end2
.bool_condition2:
	pushq $0
.bool_end2:
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	jne .if_true10
	pushq $0
	popq %rdi
	call println_int
	jmp .if_end10
.if_true10:
	pushq $2
	popq %rdi
	call println_int
.if_end10:
	pushq $1
	popq %rax
	cmpq $0, %rax
	jne .bool_condition3
	pushq $0
	jmp .bool_end3
.bool_condition3:
	pushq $0
.bool_end3:
	popq %rax
	cmpq $0, %rax
	jne .if_true11
	pushq $0
	popq %rdi
	call println_int
	jmp .if_end11
.if_true11:
	pushq $2
	popq %rdi
	call println_int
.if_end11:
	pushq $11111111
	popq %rdi
	call println_int
	pushq $1
	popq %rax
	cmpq $0, %rax
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rdi
	call println_int
	pushq $0
	popq %rax
	cmpq $0, %rax
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rdi
	call println_int
	pushq $0
	popq %rax
	cmpq $0, %rax
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .if_end12
.if_true12:
	pushq $3
	popq %rdi
	call println_int
.if_end12:
	pushq $0
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .if_end13
.if_true13:
	pushq $4
	popq %rdi
	call println_int
.if_end13:
	pushq $0
	popq %rax
	cmpq $0, %rax
	sete %al
	movzbq %al, %rax
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
	je .if_end14
.if_true14:
	pushq $4
	popq %rdi
	call println_int
.if_end14:
	pushq $11111111
	popq %rdi
	call println_int
	pushq $10
	pushq $5
	movq $0, %rdx
	popq %rbx
	popq %rax
	idivq %rbx
	pushq %rdx
	popq %rdi
	call println_int
	pushq $10
	pushq $2
	movq $0, %rdx
	popq %rbx
	popq %rax
	idivq %rbx
	pushq %rax
	popq %rdi
	call println_int
	pushq $5
	pushq $3
	movq $0, %rdx
	popq %rbx
	popq %rax
	idivq %rbx
	pushq %rdx
	popq %rdi
	call println_int
	pushq $2
	pushq $1
	movq $0, %rdx
	popq %rbx
	popq %rax
	idivq %rbx
	pushq %rdx
	popq %rdi
	call println_int
	pushq $2
	pushq $2
	movq $0, %rdx
	popq %rbx
	popq %rax
	idivq %rbx
	pushq %rdx
	popq %rdi
	call println_int
	pushq $11111111
	popq %rdi
	call println_int
	pushq $0
	popq %rax
	cmpq $0, %rax
	jne .bool_condition4
	pushq $0
	jmp .bool_end4
.bool_condition4:
	pushq $0
.bool_end4:
	popq %rax
	cmpq $0, %rax
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	jne .if_true15
	pushq $0
	popq %rdi
	call println_int
	jmp .if_end15
.if_true15:
	pushq $1
	popq %rdi
	call println_int
.if_end15:
	pushq $11111111
	popq %rdi
	call println_int
	pushq $0
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setne %al
	movzbq %al, %rax
	pushq %rax
	popq %rdi
	call println_int
	pushq $0
	pushq $1
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setne %al
	movzbq %al, %rax
	pushq %rax
	popq %rdi
	call println_int
	pushq $1
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setne %al
	movzbq %al, %rax
	pushq %rax
	popq %rdi
	call println_int
	pushq $1
	pushq $1
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setne %al
	movzbq %al, %rax
	pushq %rax
	popq %rdi
	call println_int
	pushq $11111111
	popq %rdi
	call println_int
	pushq $1
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setl %al
	movzbq %al, %rax
	pushq %rax
	pushq $1
	pushq $2
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setne %al
	movzbq %al, %rax
	pushq %rax
	popq %rdi
	call println_int
	pushq $1
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setl %al
	movzbq %al, %rax
	pushq %rax
	pushq $1
	pushq $1
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setne %al
	movzbq %al, %rax
	pushq %rax
	popq %rdi
	call println_int
	pushq $1
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setg %al
	movzbq %al, %rax
	pushq %rax
	pushq $1
	pushq $2
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setne %al
	movzbq %al, %rax
	pushq %rax
	popq %rdi
	call println_int
	pushq $1
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setg %al
	movzbq %al, %rax
	pushq %rax
	pushq $1
	pushq $1
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setne %al
	movzbq %al, %rax
	pushq %rax
	popq %rdi
	call println_int
	pushq $11111111
	popq %rdi
	call println_int
	pushq $0
	popq %rax
	movq %rax, x
.do_begin1:
	pushq x
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
	pushq x
	pushq $5
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .if_end16
.if_true16:
	jmp .do_exit1
.if_end16:
	jmp .do_begin1
.do_exit1:
	pushq $11111111
	popq %rdi
	call println_int
	pushq $0
	popq %rax
	movq %rax, x
.do_begin2:
	pushq x
	pushq $10
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
	pushq x
	pushq $8
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .if_end17
.if_true17:
	jmp .do_exit2
.if_end17:
	jmp .do_begin2
.do_exit2:
	pushq $11111111
	popq %rdi
	call println_int
	pushq $0
	popq %rax
	movq %rax, x
.do_begin3:
	pushq x
	pushq $10
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	setl %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .do_exit3
	pushq x
	pushq $1
	popq %rax
	popq %rbx
	addq %rax, %rbx
	pushq %rbx
	popq %rax
	movq %rax, x
	pushq x
	pushq $9
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	sete %al
	movzbq %al, %rax
	pushq %rax
	popq %rax
	cmpq $0, %rax
	je .if_end18
.if_true18:
	jmp .do_begin3
.if_end18:
	pushq x
	popq %rdi
	call println_int
	jmp .do_begin3
.do_exit3:
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
