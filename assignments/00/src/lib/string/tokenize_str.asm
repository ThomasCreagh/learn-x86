extern read

global tokenize_str

section .text
; -----------------------------------------------------------------------------
; tokenize_str
; -----------------------------------------------------------------------------
; Retrieves 1 line
;
; Input:
;   [ebp+8]  - buffer - bytes buffer
;   [ebp+12] - offset - int pointer
; Output:
;   eax - address of token
;
; Registers used:
; -----------------------------------------------------------------------------
tokenize_str:
	push	ebp
	mov	ebp, esp
	push	ebx
	push	esi
	push	edi
	mov	esi, [ebp+8]		; start of buffer
	mov	edi, [ebp+12]		; address of int 
	mov	edi, [edi]		; int offset
	xor	ecx, ecx		; start address

.trim:
	mov	al, [esi+edi]		; read 1 byte from buffer to token buffer
	test	al, al
	jz	.eof
	cmp	al, 32			; check if byte was space
	jne	.end_trim
	inc	edi			; buffer++
	jmp	.trim
.end_trim:

	mov	ecx, esi
	add	ecx, edi
	mov	al, [esi+edi]		; read 1 byte from buffer to token buffer
	cmp	al, 34			; check if the first byte is a quote
	jne	.normloop		; if not go to the normal loop
	inc	ecx
.quotloop:
	mov	al, [esi+edi]		; read 1 byte from buffer to token buffer
	inc	edi			; offset++
	test	al, al
	jz	.done
	cmp	al, 34			; check if byte was quote mark
	jne	.quotloop

	; after loop
	mov	byte [esi+edi-1], 0	; set the quote to a null byte
	inc 	edi			; incement the offset past the space
	jmp	.done

.normloop:
	mov	al, [esi+edi]		; read 1 byte from buffer to token buffer
	inc	edi			; offset++
	test	al, al
	jz	.done
	cmp	al, 32			; check if byte was space
	jne	.normloop

	; after loop
	mov	byte [esi+edi-1], 0	; set the space to a null byte
	jmp	.done
.done:
	; return in eax (bytes or error)
	mov	eax, ecx		; return line 
	jmp	.return
.eof:
	xor	eax, eax		; return null pointer
.return:
	mov	ebx, [ebp+12]		; get address
	mov	[ebx], edi		; update file buffer offset
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
	ret
