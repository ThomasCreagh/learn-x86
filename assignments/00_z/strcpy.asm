global strcpy

section .text
; -----------------------------------------------------------------------------
; strcpy
; -----------------------------------------------------------------------------
; Copys string from source address to destinations address
;
; Input:
;   [ebp+8]  - pointer to the destination null terminating str
;   [ebp+12] - pointer to the source null terminating str
; Output: eax - pointer to the destination str null byte
; -----------------------------------------------------------------------------
strcpy:
	push	ebp
	mov	ebp, esp	
	push	edi
	push	esi

	mov	edi, [ebp+8]	; dest = arg[0]
	mov	esi, [ebp+12]	; source = arg[1]
.loop:
	lodsb			; tmp = source[index++]
	stosb			; dest[index++] = tmp
	test	al, al		; tmp != 0?
	jnz	.loop

	dec	edi		; dest - 1 // to get null term byte
	mov	eax, edi	; return dest + index
	pop	esi
	pop	edi
	pop	ebp
	ret
