extern strlen

global print
; -----------------------------------------------------------------------------
; print
; -----------------------------------------------------------------------------
; prints null terminating string
;
; Input:
;   [esp+8] - exit message
; Output:
;   eax - sys print return call
;
; Registers used:
;   eax - distructive
;   ebx - distructive
;   ecx - distructive
;   edx - distructive
; -----------------------------------------------------------------------------
print:
	push	ebp
	mov	ebp, esp	

	push	dword [ebp+8]	; 32-bit pointer
	call	strlen		; len(arg[1])
	add	esp, 4
	mov	edx, eax	; lenght of arg[1]

	mov	eax, 4		; sys_write
	mov	ebx, 1		; stdout
	mov	ecx, [ebp+8]	; address of string
	int	0x80		; kernal interupt

	pop	ebp
	ret
