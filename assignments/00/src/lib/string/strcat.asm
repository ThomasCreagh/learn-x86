extern strcpy
extern strlen

global strcat

section .text
; -----------------------------------------------------------------------------
; strcat
; -----------------------------------------------------------------------------
; Concatanates two strings together
;
; Input:
;   [ebp+8]  - pointer to the destination null terminating str
;   [ebp+12]  - pointer to the source null terminating str
;   [ebp+16] - OPTIONAL if destination length known (0 if not known)
; Output: eax - pointer to the destination str null byte
;
; Registers used:
;   eax - return value / temp value
; -----------------------------------------------------------------------------
strcat:
	push	ebp
	mov	ebp, esp	

	mov	eax, [ebp+16]
	test	eax, eax	; is arg[2] == 0?
	jnz	.len_given
	
	push	dword [ebp+8]
	call	strlen		; eax = strlen(arg[0])
	add	esp, 4		; clean stack
.len_given:
	
	add	eax, [ebp+8]    ; address = destination + dest_length
	push	dword [ebp+12]	; arg[1]
	push	eax		; arg[0]
	call	strcpy		; strcpy(end_of_dest, str_extention)
	add	esp, 8		; clean stack

	pop	ebp
	ret
