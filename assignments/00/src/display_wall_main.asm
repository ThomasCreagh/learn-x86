extern exit
extern print
extern display_wall


global	_start

section .data
	nok	db	"nok: no identifier provided", 10, 0

section .text
; -----------------------------------------------------------------------------
; display_wall
; -----------------------------------------------------------------------------
; Displays users wall
;
; Input:
;   [esp] - number of args
;   [esp+4] - program name
;   [esp+8] - user id
; Output: ok or nok
;
; Registers used:
;   eax - return value / temporary
; -----------------------------------------------------------------------------

_start:
	; check args given
	mov	eax, [esp]	; eax = number of args
	cmp	eax, 2
	je	.arg_given	; if (eax != 2) {
	push	nok		;   print[0] = nok
	call	print		;   print err
	add	esp, 4		;   clean stack
	push	1		;   exit[0] = 1
	call	exit		; }
.arg_given:
	push	dword [esp+8]
	call	display_wall
	add	esp, 4

	; exit succefully
	push	eax		;   exit[0] = create_user status
	call	exit		; }
