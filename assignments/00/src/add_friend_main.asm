extern exit
extern print
extern add_friend


global	_start

section .data
	nok	db	"nok: no identifier provided", 0

section .text
; -----------------------------------------------------------------------------
; add_friend_main
; -----------------------------------------------------------------------------
; Adds a friend of the friend list of an id
;
; Input:
;   [esp]    - number of args
;   [esp+4]  - program name
;   [esp+8]  - user id
;   [esp+12] - friend id
; Output: ok or nok
;
; Registers used:
;   eax - return value / temporary
; -----------------------------------------------------------------------------

_start:
	; check args given
	mov	eax, [esp]	; eax = number of args
	cmp	eax, 3
	je	.arg_given	; if (eax != 3) {
	push	nok		;   print[0] = nok
	call	print		;   print err
	add	esp, 4		;   clean stack
	push	1		;   exit[0] = 1
	call	exit		; }
.arg_given:
	mov	esi, [esp+8]	; userid
	mov	edi, [esp+12]	; friendid

	push	edi
	push	esi
	call	add_friend
	add	esp, 8

	cmp	eax, 0
	jge	.exit
	mov	eax, 1

.exit:
	push	eax		;   exit[0] = create_user status
	call	exit		; }
