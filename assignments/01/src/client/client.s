        .section .data
server_pipe:    .string "../../server.pipe"
client_pipe:    .space  64
req_buf:        .space  256
resp_buf:       .space  256
pipe_suffix:    .string ".pipe"
client_prefix:  .string "../../"

        .section .text
        .globl start
        .extern strlen
        .extern strcpy

start:
        # a0 = argc, a1 = argv

        # load argv pointers (32-bit offsets)
        ld s1, 4(a1)     # argv[1] = u1
        ld s2, 8(a1)     # argv[2] = command
        ld s3, 12(a1)    # argv[3] = u2 (optional)
        ld s4, 16(a1)    # argv[4] = other (optional)

        # just after entering start
        li a0, 1               # stdout
        mv a1, s1 # temporary, or use req_buf
        li a2, 64               # length
        li a7, 64               # write
        ecall

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

        # append u2 if exists
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

        # append other if exists
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

        # open server.pipe for WRITE
        li a0, -100
        la a1, server_pipe
        li a2, 1        # O_WRONLY
        li a3, 0
        li a7, 56       # openat
        ecall
        mv s5, a0       # server_fd

        # write request
        mv a0, s5
        la a1, req_buf
        la a2, req_buf
        jal ra, strlen
        mv a2, a0
        li a7, 64       # write
        ecall

        # close server_fd
        mv a0, s5
        li a7, 57       # close
        ecall

        # build client pipe "../../<u1>.pipe"
        la a1, client_pipe
        la a0, client_prefix
        jal ra, strcpy       # copy "../../"

        la a1, client_pipe
        jal ra, strlen
        add a0, a1, a0
        mv a1, a0
        mv a0, s1
        jal ra, strcpy       # copy <u1>

        la a1, client_pipe
        jal ra, strlen
        add a0, a1, a0
        mv a1, a0
        la a0, pipe_suffix
        jal ra, strcpy       # append ".pipe"

        # open client.pipe for READ
        li a0, -100
        la a1, client_pipe
        li a2, 0        # O_RDONLY
        li a3, 0
        li a7, 56       # openat
        ecall
        mv s6, a0       # client_fd

        # read response
        mv a0, s6
        la a1, resp_buf
        li a2, 256
        li a7, 63       # read
        ecall

        # write response to stdout
        li a0, 1
        la a1, resp_buf
        la a2, resp_buf
        jal ra, strlen
        mv a2, a0
        li a7, 64       # write
        ecall

        # exit
        li a0, 0
        li a7, 93
        ecall

