global mkdir

section .text
; -----------------------------------------------------------------------------
; mkdir
; -----------------------------------------------------------------------------
; Makes a directory
;
; Input:
;   [esp+8] - dirname 
; Output: eax - pointer to the destination str null byte
;
; Registers used:
;   eax - return value / temp value
;   ebx - sys mkdir dir name (restored)
;   ecx - tmp
; -----------------------------------------------------------------------------
mkdir:
	push	ebp
	mov	ebp, esp
	push	ebx

	mov	eax, 39		; sys_mkdir
	mov	ebx, [ebp+8]	; dir name
	mov	ecx, 0777o	; rwxrwxrwx
	int	0x80

	pop ebx
	pop ebp
	ret
