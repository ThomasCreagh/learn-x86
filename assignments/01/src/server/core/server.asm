extern add_friend
extern create_user
extern display_wall
extern post_message
extern parse_input
extern read
extern print
extern strcmp

global server
global server_fd
global client_fd

section .data
	nok		db	"nok: bad request", 10, 0
	nok_error	db	"nok: there was an error", 10, 0
	create_str	db	"create", 0
	add_str		db	"add", 0
	post_str	db	"post", 0
	display_str	db	"display", 0
	server_pipe	db	"../../../server.pipe", 0
	pipe_dir	db	"../../../", 0
	pipe_ext	db	".pipe", 0
	; client_ack	db	"ACK", 0
	server_fd	dd	1
	client_fd	dd	0

section .bss
	client_pipe	resb	512
	input_buffer	resb	512
	token_array	resd	8

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
	; open server pipe for reading
	push	0			; 0 for reading
	push	server_pipe
	call	open
	add	esp, 8
	mov	[server_fd], eax
	; ; read from the server pipe for the client name
	; push	256
	; push	input_buffer
	; push	[server_fd]
	; call	read
	; add	esp, 12
	; concate pipe path
		; ; ack to client pipe
	; push	client_ack
	; call	print
	; add	esp, 4

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

	; make client pipe path
	push	pipe_dir
	push	client_pipe
	call	strcpy
	add	esp, 8
	push	[token_array+4]
	push	eax
	call	strcpy
	add	esp, 8
	push	pipe_ext
	push	eax
	call	strcpy
	add	esp, 8
	; open client pipe for writing
	push	1			; 1 for writing
	push	client_pipe
	call	open
	add	esp, 8
	mov	[client_fd], eax

	push	dword [token_array+4]		; get the first arg and push
	call	create_user
	add	esp, 4
	test	eax, eax
	jmp	.loop

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
	jmp	.loop

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
	jmp	.loop

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
	jmp	.loop

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
