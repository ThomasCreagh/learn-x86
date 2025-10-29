extern user_exists
extern user_in_file
extern get_txt
extern print
extern append_user

global add_friend

section .data
	nok_user	db	"nok: user ’$id’ does not exist", 0
	nok_frnd	db	"nok: user ’$friend’ does not exist", 0
	nok_frnded	db	"nok: user ’$friend’ exists in ’$id’'s friend list", 0
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
;   eax - 0 sucessful or 1 not
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
	mov	esi, [ebp+8]
	; save friend id
	mov	edi, [ebp+12]

	; check user existance
	push	esi
	call	user_exists	; user_exists(userid)
	add	esp, 4		; clean stack
	
	test	eax, eax
	jnz	.user_exists	; if (file exists) {
	push	nok_user	;   print[0] = nok_user
	call	print		;   print error
	add	esp, 4		;   clean stack
	mov	eax, 1		;   return val = 1
	jmp	.exit
.user_exists:
	; check friend existance
	push	edi
	call	user_exists	; user_exists(friendid)
	add	esp, 4		; clean stack
	
	test	eax, eax
	jnz	.frnd_exists	; if (file exists) {
	push	nok_frnd	;   print[0] = nok_frnd
	call	print		;   print error
	add	esp, 4		;   clean stack
	mov	eax, 1		;   return val = 1
	jmp	.exit
.frnd_exists:

	; get friends.txt
	push	buffer		; get_txt[2] = buffer
	push	1		; get_txt[1] = 1	// friend file
	push	esi		; get_txt[0] = user id
	call	get_txt
	add	esp, 12		; clean stack

	; check if user in file
	push	edi		; user_in_file->friend	
	push	buffer		; user_in_file->filepath
	call	user_in_file
	add	esp, 8		; clean stack
	cmp	eax, 0
	js	.exit
	je	.not_friend

	push	nok_frnded	;   print[0] = nok_frnded
	call	print		;   print error
	add	esp, 4		;   clean stack
	mov	eax, 1		;   return val = 1
	jmp	.exit

.not_friend:
	push	edi		; append_user->friend
	push 	buffer		; append_user->filepath
	call	append_user
	add	esp, 8		; clean stack

	xor	eax, eax
.exit:
	pop	edi
	pop	esi
	pop	ebp
	ret			; return
