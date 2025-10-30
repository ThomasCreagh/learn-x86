extern exit
extern print
extern post_message


global	_start

section .data
	nok	db	"nok: no identifier provided", 0

section .text
; -----------------------------------------------------------------------------
; post_message_main
; -----------------------------------------------------------------------------
; Posts a message on your friends wall
;
; Input:
;   [esp]    - number of args
;   [esp+4]  - program name
;   [esp+8]  - sender id
;   [esp+12] - receiver id
;   [esp+12] - message
; Output: ok or nok
;
; Registers used:
;   eax - return value / temporary
; -----------------------------------------------------------------------------

_start:
	; check args given
	mov	eax, [esp]	; eax = number of args
	cmp	eax, 4
	je	.arg_given	; if (eax != 3) {
	push	nok		;   print[0] = nok
	call	print		;   print err
	add	esp, 4		;   clean stack
	push	1		;   exit[0] = 1
	call	exit		; }
.arg_given:
	mov	eax, [esp+8]	; sender id
	mov	ecx, [esp+12]	; receiver id
	mov	edx, [esp+16]	; message

	push	edx
	push	ecx
	push	eax
	call	post_message
	add	esp, 8

	cmp	eax, 0
	jge	.exit
	mov	eax, 1

.exit:
	push	eax		;   exit[0] = create_user status
	call	exit		; }
