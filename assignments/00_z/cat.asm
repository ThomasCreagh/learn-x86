extern open
extern close
extern read
extern write

global cat

section .bss
	buffer	resb	1024


section .text
; -----------------------------------------------------------------------------
; cat
; -----------------------------------------------------------------------------
; Concatanate all byte of a file to stdout
;
; Input:
;   [ebp+8]   - filepath
; Output: eax - 0 is good neg is bad
; -----------------------------------------------------------------------------
cat:
	push	ebp
	mov	ebp, esp
	push	ebx
	push	esi

	; open file
	push	0			; read
	push	dword [ebp+8]
	call	open
	add	esp, 8
	mov	esi, eax		; fd = file descriptor

.loop:
	; read file
	push	1024			; read->size of buffer
	push	buffer			; read->buffer
	push	esi			; read->fd
	call	read
	add	esp, 12

	; check read status
	cmp	eax, 0
	js	.exit
	je	.eof

	; write to file
	push	eax			; write->size
	push	buffer			; write->buffer
	push	1			; write->stdout
	call	write
	add	esp, 12			; clean stack

	jmp	.loop
	
.eof:
	; close file
	push	esi
	call	close
	add	esp, 4

	xor	eax, eax
.exit:
	pop	esi
	pop	ebx
	pop	ebp
	ret
