	.section .data
server_pipe:	.string "server.pipe"
client_pipe:	.space  64
req_buf:	.space  256
resp_buf:	.space  256
pipe_suffix:	.string ".pipe"
	.section .text
	.globl main
	.extern strlen
	.extern strcpy
main:
	# a0 = argc, a1 = argv
	# load argv pointers (64-bit)
	mv	s0, a0        # argc = arg count

	ld	s1, 8(a1)     # argv[1] = u1
	ld	s2, 16(a1)    # argv[2] = command
	ld	s3, 24(a1)    # argv[3] = u2 (optional)
	ld	s4, 32(a1)    # argv[4] = other (optional)

	# build request string: "<command> <u1> [<u2> [<other>]>\n"
	la	a0, req_buf   # a0 = dest
	mv	a1, s2        # a1 = src (command)
	jal	ra, strcpy

	# append space + u1
	la	t1, req_buf      # Load base address FIRST
	mv	a0, t1
	jal	ra, strlen      # Get length (modifies a0)

	la	t1, req_buf      # Load base address FIRST
	add	a0, t1, a0      # a0 = base + length = pointer to end
	li	t0, ' '
	sb	t0, 0(a0)        # Write space
	addi	a0, a0, 1      # Move past space
	mv	a1, s1           # Source for strcpy
	jal	ra, strcpy

	# append u2 if exists
	li	t0, 4
	blt	s0, t0, skip
	la	a0, req_buf
	jal	ra, strlen
	la	t1, req_buf
	add	a0, a0, t1
	li	t0, ' '
	sb	t0, 0(a0)
	addi	a0, a0, 1
	mv	a1, s3        # a1 = src (u2)
	jal	ra, strcpy

	# append other if exists
	li	t0, 5
	blt	s0, t0, skip
	la	a0, req_buf
	jal	ra, strlen
	la	t1, req_buf
	add	a0, a0, t1
	li	t0, ' '
	sb	t0, 0(a0)
	addi	a0, a0, 1
	mv	a1, s4        # a1 = src (other)
	jal	ra, strcpy

skip:
	# append newline
	la	a0, req_buf
	jal	ra, strlen
	la	t1, req_buf
	add	a0, a0, t1
	li	t0, '\n'
	sb	t0, 0(a0)
	addi	a0, a0, 1
	sb	zero, 0(a0)   # null terminate
	
	# open server.pipe for WRITE
	li	a0, -100
	la	a1, server_pipe
	li	a2, 1        # O_WRONLY
	li	a3, 0
	li	a7, 56       # openat
	ecall
	mv	s5, a0       # server_fd
	
	# write request
	la	a0, req_buf
	jal	ra, strlen
	mv	t0, a0
	
	mv	a0, s5
	la	a1, req_buf
	mv	a2, t0       # length
	li	a7, 64       # write
	ecall
	
	# close server_fd
	mv	a0, s5
	li	a7, 57       # close
	ecall
	
	# build client pipe "<u1>.pipe"
	la	a0, client_pipe
	mv	a1, s1
	jal	ra, strcpy       # copy <u1>
	la	a0, client_pipe
	jal	ra, strlen
	mv	t1, a0
	la	a0, client_pipe
	add	a0, a0, t1
	la	a1, pipe_suffix
	jal	ra, strcpy       # append ".pipe"

	## === DEBUG ===
	#la	a0, client_pipe
	#jal	strlen
	#mv	t0, a0
	#
	## just after entering start
	#li	a0, 1               # stdout
	#la	a1, client_pipe              # temporary, or use req_buf
	#mv	a2, t0              # length
	#li	a7, 64              # write
	#ecall
	## === DEBUG ===

	# open client.pipe for READ
	li	a0, -100
	la	a1, client_pipe
	li	a2, 0        # O_RDONLY
	li	a3, 0
	li	a7, 56       # openat
	ecall
	mv	s6, a0       # client_fd

read_loop:
	# read response
	mv	a0, s6
	la	a1, resp_buf
	li	a2, 256
	li	a7, 63       # read
	ecall

	# if 0 or less exit loop
	blez    a0, read_done

	# save bytes read
	mv      s7, a0
	
	# write response to stdout
	li	a0, 1        # stdout
	la	a1, resp_buf
	mv	a2, s7       # length
	li	a7, 64       # write
	ecall
	j	read_loop

read_done:

	# exit
	li	a0, 0
	li	a7, 93
	ecall
