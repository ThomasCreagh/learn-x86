global user_exists

section .text
; -----------------------------------------------------------------------------
; user_exists
; -----------------------------------------------------------------------------
; Computes the length of a null-terminated string.
;
; Input: [ebp+8] - user id
; Output: eax    - if user exists it returns 0 else -1 if not exists
; -----------------------------------------------------------------------------
user_exists:
	push	ebp
	mov	ebp, esp	
	push	ebx

	mov	eax, 33		; sys_access
	mov	ebx, [ebp+8]	; user id
	xor	ecx, ecx	; F_OK = 0
	int	0x80

	pop	ebx
	pop	ebp
	ret
