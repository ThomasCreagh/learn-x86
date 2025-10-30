extern user_exists
extern user_in_file
extern get_txt
extern print
extern append_line
extern strcpy
extern strcat

global post_message

section .data
	nok_sender		db	"nok user $sender does not exist", 10, 0
	nok_receiver		db	"nok user $receiver does not exist", 10, 0
	nok_sender_fo_receiver	db	"nok user $sender is not a friend of $receiver", 10, 0
	nok_receiver_fo_sender	db	"nok user $receiver is not a friend of $sender", 10, 0
	ok			db	"ok", 10, 0
	semicolon_space		db	": ", 0

section .bss
	filename_buffer		resb	256
	message_buffer		resb	256

section .text
; -----------------------------------------------------------------------------
; post_message
; -----------------------------------------------------------------------------
; Posts a message on someones wall
;
; Input:
;   [ebp+8]  - sender id
;   [ebp+12] - receiver id
;   [ebp+16] - message
; Output:
;   eax - 0 sucessful or 1 not
;
; Registers used:
;   eax - return value / temporary
; -----------------------------------------------------------------------------
post_message:
	push	ebp
	mov	ebp, esp
	push	esi
	push	edi
	; save sender id
	mov	esi, [ebp+8]
	; save receiver id
	mov	edi, [ebp+12]

	; check sender existance
	push	esi
	call	user_exists		; user_exists(senderid)
	add	esp, 4			; clean stack
	
	test	eax, eax
	jz	.sender_exists		; if (file exists) {
	push	nok_sender		;   print[0] = nok_sender
	call	print			;   print error
	add	esp, 4			;   clean stack
	mov	eax, 1			;   return val = 1
	jmp	.exit
.sender_exists:
	; check receiver existance
	push	edi
	call	user_exists		; user_exists(receiverid)
	add	esp, 4			; clean stack
	
	test	eax, eax
	jz	.receiver_exists	; if (file exists) {
	push	nok_receiver		;   print[0] = nok_receiver
	call	print			;   print error
	add	esp, 4			;   clean stack
	mov	eax, 1			;   return val = 1
	jmp	.exit
.receiver_exists:
	; get friends.txt
	push	filename_buffer		; get_txt[2] = filename_buffer
	push	1			; get_txt[1] = 1	// friend file
	push	esi			; get_txt[0] = sender id
	call	get_txt
	add	esp, 12			; clean stack

	; check if user in file
	push	edi			; user_in_file->receiver
	push	filename_buffer		; user_in_file->filepath
	call	user_in_file
	add	esp, 8			; clean stack
	cmp	eax, 0
	js	.exit
	jg	.receiver_fo_sender	; if (receiver is not a friend of sender) {

	push	nok_receiver_fo_sender	;   print[0] = nok_receiver_fo_sender
	call	print			;   print error
	add	esp, 4			;   clean stack
	mov	eax, 1			;   return val = 1
	jmp	.exit			; }
.receiver_fo_sender:
	; get friends.txt
	push	filename_buffer		; get_txt[2] = filename_buffer
	push	1			; get_txt[1] = 1	// friend file
	push	edi			; get_txt[0] = receiver id
	call	get_txt
	add	esp, 12			; clean stack

	; check if user in file
	push	esi			; user_in_file->sender
	push	filename_buffer		; user_in_file->filepath
	call	user_in_file
	add	esp, 8			; clean stack
	cmp	eax, 0
	js	.exit
	jg	.sender_fo_receiver	; if (receiver is not a friend of sender) {

	push	nok_sender_fo_receiver	;   print[0] = nok_sender_fo_receiver
	call	print			;   print error
	add	esp, 4			;   clean stack
	mov	eax, 1			;   return val = 1
	jmp	.exit			; }

.sender_fo_receiver:
	; create message
	push	esi			; strcpy(source)->sender
	push	message_buffer		; strcpy(destination)->message_buffer
	call	strcpy
	add	esp, 8

	push	semicolon_space		; strcpy(source)->semicolon_space
	push	eax			; strcpy(destination)->message_buffer null byte
	call	strcpy
	add	esp, 8

	push	dword [ebp+16]		; strcpy(source)->message
	push	eax			; strcpy(destination)->message_buffer null byte
	call	strcpy
	add	esp, 8

	; get wall.txt
	push	filename_buffer		; get_txt[2] = filename_buffer
	push	0			; get_txt[1] = 0	// wall file
	push	edi			; get_txt[0] = receiver id
	call	get_txt
	add	esp, 12			; clean stack
	
	; append file
	push 	message_buffer		; append_line->message_buffer
	push	filename_buffer		; append_line->filename_buffer
	call	append_line
	add	esp, 8			; clean stack

	push	ok			;   print[0] = ok
	call	print			;   print ok
	add	esp, 4			;   clean stack
	xor	eax, eax
.exit:
	pop	edi
	pop	esi
	pop	ebp
	ret				; return
