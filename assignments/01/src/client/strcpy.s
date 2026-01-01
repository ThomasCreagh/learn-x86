.section .text
	.globl strcpy
# strcpy(dst=a0, src=a1) → returns dst in a0
strcpy:
	mv	t0, a0		# t0 = dst
	mv	t1, a1		# t1 = src
loop:
	lbu	t2, 0(t1)		# load byte from src
	sb	t2, 0(t0)		# store byte to dst
	beq	t2, zero, done	# if null terminator, done
	addi	t0, t0, 1
	addi	t1, t1, 1
	j	loop
done:
	ret
