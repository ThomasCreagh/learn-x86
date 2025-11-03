global strcmp

section .text
; -----------------------------------------------------------------------------
; strcmp
; -----------------------------------------------------------------------------
; Compares to strings
;
; Input:
;   [ebp+8]  - pointer to the destination null terminating str
;   [ebp+12]  - pointer to the source null terminating str
; Output:
;   eax = 0  if equal
;   eax < 0  if s1 < s2
;   eax > 0  if s1 > s2
; -----------------------------------------------------------------------------
strcmp:
	push	ebp
	mov	ebp, esp
	push	ebx
	push	esi
	push	edi

	mov	esi, [ebp+8]	; s1
	mov	edi, [ebp+12]	; s2

.loop:
	mov	al, [esi]
	mov	bl, [edi]
	cmp	al, bl
	jne	.not_equal
	test	al, al		; end of string?
	je	.equal
	inc	esi
	inc	edi
	jmp	.loop

.equal:
	xor	eax, eax	; return 0
	jmp	.done

.not_equal:
	movzx	eax, al
	movzx	ebx, bl
	sub	eax, ebx	; return difference

.done:
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
	ret
