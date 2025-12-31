	.section .text
	.globl strcpy

# strcpy(src=a0, dst=a1) → returns dst in a1
strcpy:
	mv t0, a0		# t0 = src
	mv t1, a1		# t1 = dst

loop:
	lbu t2, 0(t0)		# load byte from src
	sb  t2, 0(t1)		# store byte to dst
	beq t2, zero, done	# if null terminator, done
	addi t0, t0, 1
	addi t1, t1, 1
	j loop

done:
	mv a1, a1		# return dst in a1
	ret

