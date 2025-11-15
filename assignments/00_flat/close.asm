global close

section .text
; -----------------------------------------------------------------------------
; close
; -----------------------------------------------------------------------------
; Takes file descriptor and closes it
;
; Input:
;   [ebp+8]  - file descriptor
; Output: eax
; -----------------------------------------------------------------------------
close:
	push	ebp
	mov	ebp, esp
	push	ebx

	mov	eax, 6		; sys_close
	mov	ebx, [ebp+8]	; filedescriptor
	int	0x80		; kernal interupt

	pop	ebx
	pop	ebp
	ret

