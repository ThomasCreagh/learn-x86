global strlen

section .text
; -----------------------------------------------------------------------------
; strlen
; -----------------------------------------------------------------------------
; Computes the length of a null-terminated string.
;
; Input: [ebp+8] - pointer to the null-terminated string
; Output: eax    - length of the string
;
; Registers used:
;   eax - return value / temporary
;   ecx - length counter
;   esi - pointer to string (preserved)
; -----------------------------------------------------------------------------
strlen:
	push	ebp
	mov	ebp, esp	
	push	esi
	mov	esi, [ebp+8]	; str = arg[0]
	xor	ecx, ecx	; ecx = 0
.loop:
	mov	al, [esi+ecx]	; str[ecx]
	cmp	al, 0		; str[ecx] == 0
	je	.exit		; yes -> exit
	inc	ecx		; no -> increment ecx
	jmp	.loop
.exit:
	mov	eax, ecx	; return ecx
	pop	esi
	pop	ebp
	ret
