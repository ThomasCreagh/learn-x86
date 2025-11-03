global read

section .text
; -----------------------------------------------------------------------------
; read
; -----------------------------------------------------------------------------
; Reads the contents length size of a file
;
; Input:
;   [ebp+8]  - file descriptor
;   [ebp+12] - buffer
;   [ebp+16] - size
; Output: eax - bytes read or neg errors
; -----------------------------------------------------------------------------
read:
	push	ebp
	mov	ebp, esp
	push	ebx

	; read entire file to buffer
	mov	eax, 3		; sys_read
	mov	ebx, [ebp+8]	; file descriptor
	mov	ecx, [ebp+12]	; buffer
	mov	edx, [ebp+16]	; size
	int	0x80

	pop	ebx
	pop	ebp
	ret
