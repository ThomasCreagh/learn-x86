global exit
; -----------------------------------------------------------------------------
; exit
; -----------------------------------------------------------------------------
; exits create_user program with exit text if 0 print stdout if 1 print stderr
;
; Input:
;   [ebp+8]  - exit code
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

	mov	eax, 1		; sys_exit
	mov	ebx, [ebp+8]	; exit code
	int	0x80		; kernal interupt
