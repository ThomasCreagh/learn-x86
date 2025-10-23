global read_line

section .text
; -----------------------------------------------------------------------------
; read_line
; -----------------------------------------------------------------------------
; Retrieves 1 line
;
; Input:
;   [ebp+8]   - file descriptor - fd
;   [ebp+12]  - line buffer     - 256 byte buffer
;   [ebp+16]  - chuck buffer    - 1024 bytes buffer
;   [ebp+20]  - chunk offset    - int
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
	push	edi ; check if chunk offset is 0 or over
	; yes -> read 1024 bytes from file
	; no -> continue reading bytes from offset into buffer until \n or EOF
	; not sure what to return in eax, but the line buffer should be changed

	mov	esi, [ebp+8]

	cmp	eax, 0
	js	.return		; if error (eax < 0)

	mov	esi, eax	; save file descriptor

	; read entire file to buffer
	mov	eax, 3		; sys_read
	mov	ebx, esi	; file descriptor
	mov	ecx, [ebp+12]	; buffer
	mov	edx, [ebp+16]	; size
	int	0x80

	mov	edi, eax	; read bytes

	; close file
	mov	eax, 6 ; sys_close
	mov	ebx, esi
	int	0x80

	mov	eax, edi

.return:
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
	ret
