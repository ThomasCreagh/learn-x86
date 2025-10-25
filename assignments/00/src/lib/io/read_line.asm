extern read

global read_line

section .text
; -----------------------------------------------------------------------------
; read_line
; -----------------------------------------------------------------------------
; Retrieves 1 line
;
; Input:
;   [ebp+8]   - file descriptor       - fd
;   [ebp+12]  - line buffer           - 256 byte buffer
;   [ebp+16]  - file buffer           - 1024 bytes buffer
;   [ebp+20]  - file buffer offset    - int
; Output:
;   eax - Number of bytes written to line buffer (including \n if present), 0 if EOF, Neg if syscall error code (eax from read)
;
; Registers used:
; -----------------------------------------------------------------------------
read_line:
	push	ebp
	mov	ebp, esp
	push	ebx
	push	esi
	push	edi
    mov    edi, [ebp+20]    ; file offset = arg[4]
    xor    esi, esi        ; line offset = 0
    ; check if file buffer offset is 0 or over
    test    edi, edi
    jnz    .offset_not_zero
    ; yes -> read 1024 bytes from file
.read:
    push    1024
    push    [ebp+16]
    push    [ebp+8]
    call    read
    add    esp, 12
    cmp    eax, 0
    jlt    .return
    mov    edi, 0    ; file offset = 0
.offset_not_zero:
    
	; no -> continue reading bytes from offset into buffer until \n or EOF
    mov    eax, [ebp+16]    ; eax = file buffer
    mov    ebx, [ebp+12]    ; ebx = line buffer
.loop:
    cmp    edi, 1024    ; if file offset >= 1024
    jge    .read
    cmp    esi, 256    ; if line offset >= 256
    jge    .overflow
    mov    al, [eax+edi]
    mov    [ebx+esi], al
    inc    edi
    inc    esi
    cmp    al, '\0'
    je    .done
    cmp    al, '\n'
    je    .done
    jmp    .loop 
.done:
    ; return in eax (bytes or error)
    mov     eax, esi            ; return line length
    mov     [ebp+20], edi       ; update file buffer offset
    jmp     .return

.overflow:
    mov     eax, -1
    jmp     .return

.return:
    pop     edi
    pop     esi
    pop     ebx
    pop     ebp
    ret