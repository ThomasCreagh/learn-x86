extern open
extern close
extern read_line
extern strcmp

global user_in_file

section .bss
	file_buffer	resb	1024
	line_buffer	resb	256
	file_offset	resd	1      ; reserve 4 bytes (int)
	bytes_read	resd	1      ; reserve 4 bytes (int)

section .text
; -----------------------------------------------------------------------------
; user_in_file
; -----------------------------------------------------------------------------
; Reads the full contents of a file
;
; Input:
;   [ebp+8]   - filename (string)
;   [ebp+12]  - user     (string)
; Output: eax - 0 for false 1 for true, neg for error
;
; Registers used:
; -----------------------------------------------------------------------------
user_in_file:
	push	ebp
	mov	ebp, esp
	push	ebx
	push	esi
	push	edi

	; open file
	push	dword [ebp+8]			; open->filename = filename
	call	open
	add	esp, 4

	; init vars
	mov	esi, eax		; fd = fd
	mov	dword [file_offset], 0	; file_offset = 0
	mov	dword [bytes_read], 0		; bytes_read = 0

.loop:
	; read lines
	push	bytes_read		; read_line->bytes_read
	push	file_offset		; read_line->file_offset
	push	file_buffer		; read_line->file_buffer
	push	line_buffer		; read_line->line_buffer
	push	esi			; read_line->fd
	call	read_line
	add	esp, 20			; clean stack
	test	eax, eax		; chekcing if bytes written is 0
	js	.return			; if negative, exit early with eax = error code
	jz	.not_equal

	; string compare
	push	line_buffer		; strcmp->read_line
	push	dword [ebp+12]		; strcmp->user
	call	strcmp
	add	esp, 8			; clean stack

	test	eax, eax		; check if equal
	jz	.equal

	jmp	.loop

.not_equal:
	xor	eax, eax
	jmp	.return

.equal:
	mov	eax, 1

.return:
	push	esi			; close->fd = fd
	call	close
	add	esp, 4

	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
	ret
