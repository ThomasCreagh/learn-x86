extern read

global read_line

section .text
; -----------------------------------------------------------------------------
; read_line
; -----------------------------------------------------------------------------
; Retrieves 1 line
;
; Input:
;   [ebp+8]   - file_descriptor       - fd
;   [ebp+12]  - line_buffer           - 256 byte buffer
;   [ebp+16]  - file_buffer           - 1024 bytes buffer
;   [ebp+20]  - file_buffer_offset    - int pointer
;   [ebp+24]  - byte_read             - int pointer
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
	mov	edi, [ebp+20]
	mov	edi, [edi]		; file offset = arg[4]
	mov	edx, [ebp+24]
	mov	edx, [edx]		; bytes read = ardg[5]
	xor	esi, esi		; line offset = 0
	; check if file buffer offset is 0 or over
	test	edi, edi		; check file offest is not 0
	jnz	.offset_not_zero
	; yes -> read 1024 bytes from file
.read:
	push	1024			; read->size = 1024
	push	[ebp+16]		; read->buffer = file buffer
	push	[ebp+8]			; read->file_descriptor = fd
	call	read
	add	esp, 12			; clean stack
	mov	edx, eax		; bytes_read = read return
	cmp	eax, 0
	mov	eax, [ebp+16]		; eax = file buffer
	mov	ebx, [ebp+12]		; ebx = line buffer
	je	.done			; if read return == 0 goto .done
	jl	.return			; if read return < 0 goto .return
	mov	edi, 0			; file offset = 0

.offset_not_zero:
	; no -> continue reading bytes from offset into buffer until \n or EOF
.loop:
	cmp	esi, 255		; if line offset >= 256 - 1 (for null byte) goto .overflow
	jge	.overflow
	cmp	edi, edx		; if file offset >= 1024 goto .read
	jge	.read
	mov	al, [eax+edi]		; read 1 byte from file buffer to line buffer
	mov	[ebx+esi], al
	inc	edi			; file offset++
	inc	esi			; line offeset++
	cmp	al, '\n'		; check if byte was a next line character
	je	.done
	jmp	.loop 
.done:
	mov	byte [ebx+esi], 0	; set end of buffer to a null byte
	; return in eax (bytes or error)
	mov	eax, esi		; return line length
	jmp	.return
.overflow:
	mov	byte [ebx+255], 0
	mov	eax, -1
.return:
	mov	ebx, [ebp+20]		; get address
	mov	[ebx], edi		; update file buffer offset
	mov	ebx, [ebp+24]		; get address
	mov	[ebx], edx		; update bytes read offset
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
	ret
