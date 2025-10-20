extern strlen

global exit
; -----------------------------------------------------------------------------
; exit
; -----------------------------------------------------------------------------
; exits create_user program with exit text if 0 print stdout if 1 print stderr
;
; Input:
;   [esp+8]  - exit code
;   [esp+12] - exit message
;
; Registers used:
;   eax - distructive
;   ebx - distructive
;   ecx - distructive
;   edx - distructive
; -----------------------------------------------------------------------------
exit:
	push	ebp
	mov	ebp, esp	

	push	dword [ebp+12]	; 32-bit pointer
	call	strlen		; len(arg[1])
	add	esp, 4
	mov	edx, eax	; lenght of arg[1]

	mov	eax, 4		; sys_write
	mov	ebx, [ebp+8]	; ebx = arg[0]
	inc	ebx		; ebx print stdout or stderr depending on exit code
	mov	ecx, [ebp+12]	; address of string
	int	0x80		; kernal interupt

	mov	eax, 1		; sys_exit
	mov	ebx, [ebp+8]	; exit code
	int	0x80		; kernal interupt
