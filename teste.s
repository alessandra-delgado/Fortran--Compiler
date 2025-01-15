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
	jne .bool_true1
	pushq $0
	jmp .bool_end1
.bool_true1:
	pushq $1
	pushq $0
	popq %rax
	cmpq $0, %rax
	jne .bool_end1
	popq %rax
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
	je .bool_false2
	pushq $1
	jmp .bool_end2
.bool_false2:
	pushq $0
	pushq $0
	popq %rax
	cmpq $0, %rax
	je .bool_end2
	popq %rax
	pushq $1
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
	jne .bool_true3
	pushq $0
	jmp .bool_end3
.bool_true3:
	pushq $1
	pushq $0
	popq %rax
	cmpq $0, %rax
	jne .bool_end3
	popq %rax
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
