global touch

section .text
; -----------------------------------------------------------------------------
; touch
; -----------------------------------------------------------------------------
; Makes a blank file
;
; Input:
;   [esp+8] - filename 
; Output: eax - pointer to the destination str null byte
;
; Registers used:
;   eax - return value / temp value
;   ebx - sys mkdir file name (restored)
;   ecx - tmp
;   edx - file permision
;   esi - file descriptor (restored)
; -----------------------------------------------------------------------------
touch:
	push	ebp
	mov	ebp, esp
	push	ebx
	push	esi

	mov	eax, 5		; sys_open
	mov	ebx, [ebp+8]	; filename
	mov	ecx, 01101o	; O_CREAT | O_WRONLY | O_TRUNC
	mov	edx, 0644o	; rw-r--r--
	int	0x80		; kernal interupt

	mov	esi, eax	; save file descriptor

	mov	eax, 6		; sys_close
	mov	ebx, esi	; filedescriptor
	int	0x80		; kernal interupt

	pop esi
	pop ebx
	pop ebp
	ret
