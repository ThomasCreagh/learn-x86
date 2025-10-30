extern open
extern close

global touch

section .text
; -----------------------------------------------------------------------------
; touch
; -----------------------------------------------------------------------------
; Makes a blank file
;
; Input:
;   [ebp+8] - filename 
; Output: eax - pointer to the destination str null byte
;
; Registers used:
;   eax - return value / temp value
;   ebx - sys mkdir file name (restored)
; -----------------------------------------------------------------------------
touch:
	push	ebp
	mov	ebp, esp
	push	ebx

	; open and create file
	push	1			; create and wronly
	push	dword [ebp+8]
	call	open
	add	esp, 8

	; close file
	push	eax
	call	close
	add	esp, 4

	pop ebx
	pop ebp
	ret
