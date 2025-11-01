extern add_friend
extern create_user
extern display_wall
extern post_message
extern parse_input
extern read
extern print
extern strcmp

global server

section .data
	nok			db	"nok: bad request", 10, 0
	nok_error		db	"nok: there was an error", 10, 0
	create_str		db	"create", 0
	add_str			db	"add", 0
	post_str		db	"post", 0
	display_str		db	"display", 0

section .bss
	input_buffer		resb	512
	token_array		resd	8

section .text
; -----------------------------------------------------------------------------
; server
; -----------------------------------------------------------------------------
; Manages input and runs nessasry subroutines
; -----------------------------------------------------------------------------
server:
	push	ebp
	mov	ebp, esp
	push	esi
	push	edi
	; save user id
.loop:
	push	token_array
	push	input_buffer
	call	parse_input
	add	esp, 8
	mov	esi, eax
	cmp	esi, 1
	jl	.loop
	je	.bad_request

.create:
	push	create_str
	push	dword [token_array]
	call	strcmp
	add	esp, 8
	test	eax, eax
	jnz	.add
	cmp	esi, 2
	jne	.bad_request
	push	dword [token_array+4]		; get the first arg and push
	call	create_user
	add	esp, 4
	test	eax, eax
	jz	.loop
	jmp	.error

.add:
	push	add_str
	push	dword [token_array]
	call	strcmp
	add	esp, 8
	test	eax, eax
	jnz	.post
	cmp	esi, 3
	jne	.bad_request
	push	dword [token_array+8]		; get the first arg and push
	push	dword [token_array+4]		; get the second arg and push
	call	add_friend
	add	esp, 8
	test	eax, eax
	jz	.loop
	jmp	.error

.post:
	push	post_str
	push	dword [token_array]
	call	strcmp
	add	esp, 8
	test	eax, eax
	jnz	.display
	cmp	esi, 4
	jne	.bad_request
	push	dword [token_array+12]	; get the first arg and push
	push	dword [token_array+8]		; get the second arg and push
	push	dword [token_array+4]		; get the third arg and push
	call	post_message
	add	esp, 12
	test	eax, eax
	jz	.loop
	jmp	.error

.display:
	push	display_str
	push	dword [token_array]
	call	strcmp
	add	esp, 8
	test	eax, eax
	jnz	.bad_request
	cmp	esi, 2
	jne	.bad_request
	push	dword [token_array+4]		; get the first arg and push
	call	display_wall
	add	esp, 4
	test	eax, eax
	jz	.loop
	jmp	.error

.bad_request:
	push	nok
	call	print
	add	esp, 4
	jmp	.loop

.error:
	push	nok_error
	call	print
	add	esp, 4

.exit:
	pop	edi
	pop	esi
	pop	ebp
	ret				; return
