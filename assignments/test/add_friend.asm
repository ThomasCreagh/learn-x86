extern user_exists
extern user_in_file
extern get_txt
extern printf
extern print
extern append_line

global add_friend

section .data
	nok_user	db	"nok: user $ does not exist", 10, 0	; id
	nok_frnd	db	"nok: user $ does not exist", 10, 0	; friend
	nok_frnded	db	"nok: user $ exists in $'s friend list", 10 , 0	; friend, id
	ok		db	"ok", 10, 0


section .bss
	buffer	resb	256

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
	jz	.user_exists	; if (file exists) {
	push	esi		;   print[1] = $id
	push	nok_user	;   print[0] = nok_user
	call	printf		;   printf error
	add	esp, 8		;   clean stack
	mov	eax, 1		;   return val = 1
	jmp	.exit
.user_exists:
	; check friend existance
	push	edi
	call	user_exists	; user_exists(friendid)
	add	esp, 4		; clean stack
	
	test	eax, eax
	jz	.frnd_exists	; if (file exists) {
	push	edi		;   print[1] = $friend
	push	nok_frnd	;   print[0] = nok_frnd
	call	printf		;   printf error
	add	esp, 8		;   clean stack
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

	push	edi		;   print[2] = $friend
	push	esi		;   print[1] = $user
	push	nok_frnded	;   print[0] = nok_frnded
	call	printf		;   printf error
	add	esp, 12		;   clean stack
	mov	eax, 1		;   return val = 1
	jmp	.exit

.not_friend:
	push	edi		; append_line->friend
	push 	buffer		; append_line->filepath
	call	append_line
	add	esp, 8		; clean stack

	push	ok		;   print[0] = ok
	call	print		;   print ok
	add	esp, 4		;   clean stack
	xor	eax, eax
.exit:
	pop	edi
	pop	esi
	pop	ebp
	ret			; return
