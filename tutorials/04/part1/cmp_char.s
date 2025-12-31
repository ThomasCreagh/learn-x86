	.text
	.globl cmp_char

cmp_char:
	bltu	a0, a1, Less
	bgtu	a0, a1, Greater
	li	a0, 0
	ret

Greater:
	li	a0, 1
	ret

Less:
	li	a0, -1
	ret

