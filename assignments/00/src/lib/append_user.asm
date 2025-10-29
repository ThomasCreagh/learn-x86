extern open
extern close
extern strcpy
extern write

global append_user

section .bss
	user_str	resb	128


section .text
; -----------------------------------------------------------------------------
; append_user
; -----------------------------------------------------------------------------
; Appends user to file
;
; Input:
;   [ebp+8]   - filepath
;   [ebp+12]  - user
; Output: eax - pointer to the destination str null byte
;
; Registers used:
; -----------------------------------------------------------------------------
append_user:
	push	ebp
	mov	ebp, esp
	push	ebx
	push	esi
	push	edi

	; open file
	push	dword [ebp+8]
	call	open
	add	esp, 4
	mov	esi, eax		; fd = file descriptor

	; cpy user into buffer to add \n
	push	dword [ebp+12]
	push	user_str
	call	strcpy
	add	esp, 8

	; replace null byte with user str with \n
	mov	byte [eax], 10		; dest null byte = '\n'
	inc	eax

	; write to file
	push	eax			; write->size
	push	user_str		; write->size
	push	esi			; write->fd
	call	write
	add	esp, 12			; clean stack
	mov	edi, eax
	
	; close file
	push	esi
	call	close
	add	esp, 4

	mov	eax, edi
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
	ret
