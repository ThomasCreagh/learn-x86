; hello.asm - Hello world using Linux syscalls (uasm / MASM syntax)

        option casemap:none        ; case-sensitive symbols

        .data
helloMessage db "Hello, world!", 10
helloLen     equ $ - helloMessage

        .code
main proc
        mov     rax, 1             ; sys_write
        mov     rdi, 1             ; fd = stdout
        lea     rsi, helloMessage  ; buffer
        mov     rdx, helloLen      ; length
        syscall

        mov     rax, 60            ; sys_exit
        xor     rdi, rdi           ; exit code 0
        syscall
main endp

        end main

