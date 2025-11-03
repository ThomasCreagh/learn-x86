global mkdir

section .text
; -----------------------------------------------------------------------------
; mkdir
; -----------------------------------------------------------------------------
; Makes a directory
;
; Input:
;   [ebp+8] - dirname 
; Output: eax - pointer to the destination str null byte
; -----------------------------------------------------------------------------
mkdir:
	push	ebp
	mov	ebp, esp
	push	ebx

	mov	eax, 39		; sys_mkdir
	mov	ebx, [ebp+8]	; dir name
	mov	ecx, 0755o	; rwxrwxrwx
	int	0x80

	pop ebx
	pop ebp
	ret
