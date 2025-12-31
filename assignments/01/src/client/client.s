	.section .data
server_pipe:	.string		"../../server.pipe"
client_pipe:	.space		64
req_buf:	.space		256
resp_buf:	.space		256

	.section .text
	.globl start

	.extern strlen
	.extern strcpy

start:
	# a0 = argc, a1 = argv

	# argv[1] = username
	lw t0, 4(a1)
	mv s1, t0		# username ptr

	# argv[2] = command
	lw t1, 8(a1)
	mv s2, t1		# command ptr

	# build request string: "<cmd> <user>\n"
	mv a0, s2
	la a1, req_buf
	jal ra, strcopy
	la a1, req_buf
	jal ra, strlen
	add a0, a1, a0
	li t2, ' '
	sb t2, 0(a0)
	addi a0, a0, 1
	mv a1, a0
	mv a0, s1
	jal ra, strcopy
	la a1, req_buf
	jal ra, strlen
	add a0, a1, a0
	li t2, '\n'
	sb t2, 0(a0)

	# open server.pipe for WRITE
	li a0, -100		# dirfd
	la a1, server_pipe
	li a2, 1		# O_WRONLY
	li a3, 0
	li a7, 56		# openat
	ecall
	mv s3, a0		# server_fd

	# write request
	mv a0, s3
	la a1, req_buf
	li a2, 256
	li a7, 64
	ecall

	# close server fd
	mv a0, s3
	li a7, 57
	ecall

	# build client pipe "<username>.pipe"
	mv a0, s1
	la a1, client_pipe
	jal ra, strcopy
	la a1, client_pipe
	jal ra, strlen
	add a0, a1, a0
	la t0, pipe_suffix
	mv a1, t0
	jal ra, strcopy

	# open client pipe for READ
	li a0, -100
	la a1, client_pipe
	li a2, 0		# O_RDONLY
	li a3, 0
	li a7, 56
	ecall
	mv s4, a0		# client_fd

	# read response
	mv a0, s4
	la a1, resp_buf
	li a2, 256
	li a7, 63
	ecall

	# write to stdout
	li a0, 1
	la a1, resp_buf
	mv a2, a0
	li a7, 64
	ecall

	# exit
	li a0, 0
	li a7, 93
	ecall

pipe_suffix:
    .string ".pipe"



