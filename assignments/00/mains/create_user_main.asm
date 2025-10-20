extern exit
extern create_user


global	_start

section .data
	nok	db	"nok: no identifier provided", 0

section .text
; -----------------------------------------------------------------------------
; create_user_main
; -----------------------------------------------------------------------------
; Create files for user init.
;
; Input:
;   [esp] - number of args
;   [esp+4] - program name
;   [esp+8] - user id
; Output: eax - length of the string
;
; Registers used:
;   eax - return value / temporary
; -----------------------------------------------------------------------------

_start:
	; check args given
	mov	eax, [esp]	; eax = number of args
	cmp	eax, 2
	je	.arg_given	; if (eax != 2) {
	push	nok		;   exit[1] = nok_0
	push	1		;   exit[0] = 1
	call	exit		; }
.arg_given:
	push	dword [esp+8]
	call	create_user
	add	esp, 4

	; exit succefully
	push	eax		;   exit[1] = ok_0
	push	edx		;   exit[0] = 0
	call	exit		; }
