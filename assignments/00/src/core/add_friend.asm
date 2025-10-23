extern user_exists
extern get_txt
extern mkdir
extern touch
extern print

global	add_friend

section .data
	nok_user	db	"nok: user ’$id’ does not exist", 0
	nok_frnd	db	"nok: user ’$friend’ does not exist", 0
	ok		db	"ok", 0


section .bss
	buffer	resb	128

section .text
; -----------------------------------------------------------------------------
; add_friend
; -----------------------------------------------------------------------------
; Adds a friend of the friend list of an id
;
; Input:
;   [esp+8]  - user id
;   [esp+12] - friend id
; Output:
;   eax - sucessful or not
;
; Registers used:
;   eax - return value / temporary
; -----------------------------------------------------------------------------
add_friend:
	push	ebp
	mov	ebp, esp
	push	esi
	push	edi
	; save user id
	mov	esi, [esp+8]
	; save friend id
	mov	edi, [esp+12]

	; check user existance
	push	esi
	call	user_exists	; user_exists(userid)
	add	esp, 4		; clean stack
	
	test	eax, eax
	jnz	.user_not_exists; if (file exists) {
	push	nok_user	;   print[0] = nok_user
	call	print		;   print error
	add	esp, 4		;   clean stack
	mov	eax, 1		;   return val = 1
	jmp	.exit
.user_not_exists:
	; check friend existance
	push	edi
	call	user_exists	; user_exists(friendid)
	add	esp, 4		; clean stack
	
	test	eax, eax
	jnz	.frnd_not_exists; if (file exists) {
	push	nok_frnd	;   print[0] = nok_frnd
	call	print		;   print error
	add	esp, 4		;   clean stack
	mov	eax, 1		;   return val = 1
	jmp	.exit
.frnd_not_exists:







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
	;mov	edi, buffer
	;mov	ecx, 32        ; 128 bytes / 4 bytes per store = 32
	;xor	eax, eax       ; clear 32-bit register
	;rep	stosd          ; store EAX into [EDI], 4 bytes at a time

	; make friends.txt
	push	buffer		; get_txt[2] = buffer
	push	1		; get_txt[1] = 0	// wall file
	push	esi		; get_txt[0] = user id
	call	get_txt
	add	esp, 12

	push	buffer		; touch[0] = buffer
	call	touch
	add	esp, 4		; clean stack

	; return successfully
	push	ok		; print[0] = ok
	call	print
	add	esp, 4		; clean stack
	xor	eax, eax	; return val = 0

.exit:
	push	edi
	push	esi
	pop	ebp
	ret			; return
