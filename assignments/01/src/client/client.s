	.section .data
server_pipe:	.string	"../../server.pipe"
client_pipe:	.space	64
req_buf:	.space	256
resp_buf:	.space	256
client_prefix:	.string "../../"
pipe_suffix:	.string ".pipe"

	.section .text
	.globl start
	.extern strlen
	.extern strcpy

start:
	# a0 = argc, a1 = argv

	# argv[1] = u1
	lw t0, 4(a1)
	mv s1, t0

	# argv[2] = command
	lw t1, 8(a1)
	mv s2, t1

	# argv[3] = u2 (optional)
	lw t2, 12(a1)
	mv s3, t2

	# argv[4] = other (optional)
	lw t3, 16(a1)
	mv s4, t3

	# build request string: "<command> <u1> [<u2> [<other>]]\n"
	la a1, req_buf
	mv a0, s2
	jal ra, strcpy

	# append space + u1
	la a1, req_buf
	jal ra, strlen
	add a0, a1, a0
	li t0, ' '
	sb t0, 0(a0)
	addi a0, a0, 1
	mv a1, a0
	mv a0, s1
	jal ra, strcpy

	# if u2 exists
	beqz s3, skip_u2
	la a1, req_buf
	jal ra, strlen
	add a0, a1, a0
	li t0, ' '
	sb t0, 0(a0)
	addi a0, a0, 1
	mv a1, a0
	mv a0, s3
	jal ra, strcpy
skip_u2:

	# if other exists
	beqz s4, skip_other
	la a1, req_buf
	jal ra, strlen
	add a0, a1, a0
	li t0, ' '
	sb t0, 0(a0)
	addi a0, a0, 1
	mv a1, a0
	mv a0, s4
	jal ra, strcpy
skip_other:

	# append newline
	la a1, req_buf
	jal ra, strlen
	add a0, a1, a0
	li t0, '\n'
	sb t0, 0(a0)

	# open server.pipe for write
	li a0, -100
	la a1, server_pipe
	li a2, 1	# O_WRONLY
	li a3, 0
	li a7, 56
	ecall
	mv s5, a0	# server_fd

	# write request
	mv a0, s5
	la a1, req_buf
	la a2, req_buf
	jal ra, strlen
	mv a2, a0
	li a7, 64
	ecall

	# close server_fd
	mv a0, s5
	li a7, 57
	ecall

	# build client pipe "<u1>.pipe"
	la a1, client_pipe
	mv a0, s1
	jal ra, strcpy
	la a1, client_pipe
	la a0, pipe_suffix
	jal ra, strcpy

	# open client.pipe for read
	li a0, -100
	la a1, client_pipe
	li a2, 0	# O_RDONLY
	li a3, 0
	li a7, 56
	ecall
	mv s6, a0	# client_fd

	# read response
	mv a0, s6
	la a1, resp_buf
	li a2, 256
	li a7, 63
	ecall

	# write response to stdout
	li a0, 1
	la a1, resp_buf
	li a2, 256
	li a7, 64
	ecall

	# exit
	li a0, 0
	li a7, 93
	ecall

