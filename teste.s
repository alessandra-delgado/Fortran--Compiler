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
	pushq $7
	pushq $10
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	jl .condition_true1
	pushq $0
	jmp .condition_end1
.condition_true1:
	pushq $1
.condition_end1:
	popq %rdi
	call println_int
	pushq $7
	pushq $0
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	jne .condition_true2
	pushq $0
	jmp .condition_end2
.condition_true2:
	pushq $1
.condition_end2:
	popq %rdi
	call println_int
	pushq $7
	pushq $7
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	jne .condition_true3
	pushq $0
	jmp .condition_end3
.condition_true3:
	pushq $1
.condition_end3:
	popq %rdi
	call println_int
	pushq $7
	pushq $6
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	je .condition_true4
	pushq $0
	jmp .condition_end4
.condition_true4:
	pushq $1
.condition_end4:
	popq %rdi
	call println_int
	pushq $7
	pushq $7
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	je .condition_true5
	pushq $0
	jmp .condition_end5
.condition_true5:
	pushq $1
.condition_end5:
	popq %rdi
	call println_int
	pushq $0
	pushq $0
	pushq $2
	popq %rax
	popq %rbx
	subq %rax, %rbx
	pushq %rbx
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	jg .condition_true6
	pushq $0
	jmp .condition_end6
.condition_true6:
	pushq $1
.condition_end6:
	popq %rdi
	call println_int
	pushq $0
	pushq $7
	pushq $2
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	jg .condition_true8
	pushq $0
	jmp .condition_end8
.condition_true8:
	pushq $1
.condition_end8:
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	jl .condition_true7
	pushq $0
	jmp .condition_end7
.condition_true7:
	pushq $1
.condition_end7:
	popq %rdi
	call println_int
	pushq $4
	pushq $4
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	je .condition_true10
	pushq $0
	jmp .condition_end10
.condition_true10:
	pushq $1
.condition_end10:
	pushq $6
	popq %rax
	popq %rbx
	cmpq %rax, %rbx
	je .condition_true9
	pushq $0
	jmp .condition_end9
.condition_true9:
	pushq $1
.condition_end9:
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
