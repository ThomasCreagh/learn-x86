extern exit
extern user_exists
extern get_txt
extern mkdir
extern touch

global	_start

section .data
	nok_0	db	"nok: no identifier provided", 0
	nok_1	db	"nok: user already exists", 0
	ok_0	db	"ok: user created!", 0


section .bss
	buffer	resb	128

section .text
; -----------------------------------------------------------------------------
; create_user
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
	push	nok_0		;   exit[1] = nok_0
	push	1		;   exit[0] = 1
	call	exit		; }
.arg_given:
	; save userid
	mov	esi, [esp+8]

	; check user existance
	push	esi
	call	user_exists	; user_exists(argv[1])
	add	esp, 4		; clean stack
	
	test	eax, eax
	jnz	.not_exists	; if (file exists) {
	push	nok_1		;   exit[1] = nok_1
	push	1		;   exit[0] = 1
	call	exit		; }
.not_exists:
	; make dir
	push	esi		; mkdir[0] = arg[1]
	call	mkdir
	add	esp, 4		; clean stack
	
	; make wall.txt
	push	buffer		; get_txt[2] = buffer
	push	0		; get_txt[1] = 0	// wall file
	push	esi		; get_txt[0] = user id
	call	get_txt
	add	esp, 12

	push	buffer		; touch[0] = buffer
	call	touch
	add	esp, 4		; clean stack

	; clear buffer
	mov	edi, buffer
	mov	ecx, 32        ; 128 bytes / 4 bytes per store = 32
	xor	eax, eax       ; clear 32-bit register
	rep	stosd          ; store EAX into [EDI], 4 bytes at a time

	; make friends.txt
	push	buffer		; get_txt[2] = buffer
	push	1		; get_txt[1] = 0	// wall file
	push	esi		; get_txt[0] = user id
	call	get_txt
	add	esp, 12

	push	buffer		; touch[0] = buffer
	call	touch
	add	esp, 4		; clean stack

	; exit succefully
	push	ok_0		;   exit[1] = ok_0
	push	0		;   exit[0] = 0
	call	exit		; }
