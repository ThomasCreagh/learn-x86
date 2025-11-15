extern exit
extern print
extern server


global	_start

section .text
; -----------------------------------------------------------------------------
; server
; -----------------------------------------------------------------------------
; Manages input and runs nessasry subroutines
; -----------------------------------------------------------------------------
_start:
	; check args given
	mov	eax, [esp]	; eax = number of args
	cmp	eax, 1
	je	.arg_given	; if (eax != 1) {
	push	1		;   exit[0] = 1
	call	exit		; }
.arg_given:
	call	server

	; exit succefully
	push	eax		;   exit[0] = create_user status
	call	exit		; }
