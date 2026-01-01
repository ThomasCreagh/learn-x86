	.section .text
	.globl strlen

# strlen(buf=a0) → a0 = length
strlen:
	mv	t0, a0
	mv	t2, a0
loop:
	lbu	t1, 0(t0)
	beq	t1, zero, end
	addi	t0, t0, 1
	j	loop
end:
	sub	a0, t0, t2
	ret

