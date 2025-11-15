global write

section .text
; -----------------------------------------------------------------------------
; write
; -----------------------------------------------------------------------------
; Writes the contents length size of a file
;
; Input:
;   [ebp+8]  - file descriptor
;   [ebp+12] - buffer
;   [ebp+16] - size
; Output: eax - bytes written or neg errors
; -----------------------------------------------------------------------------
write:
	push	ebp
	mov	ebp, esp
	push	ebx

	; write buffer to file
	mov	eax, 4		; sys_write
	mov	ebx, [ebp+8]	; file descriptor
	mov	ecx, [ebp+12]	; buffer
	mov	edx, [ebp+16]	; size
	int	0x80

	pop	ebx
	pop	ebp
	ret
