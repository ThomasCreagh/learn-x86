extern strcpy
extern open

global connect_pipe
global server_pipe
global client_pipe
global server_fd
global client_fd

section .data
	server_pipe	db	"server.pipe", 0
	pipe_ext	db	".pipe", 0
	server_fd	dd	1
	client_fd	dd	0

section .bss
	client_pipe	resb	512

section .text
; -----------------------------------------------------------------------------
; connect_pipe
; -----------------------------------------------------------------------------
; connect_pipe connects to the clients pipe
;
; Input:
;   [ebp+8]  - pipe name
; -----------------------------------------------------------------------------
connect_pipe:
	push	ebp
	mov	ebp, esp
	push	ebx

	; make client pipe path
	;push	dword [token_array+4]
	push	dword [ebp+8]
	push	client_pipe
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

	pop ebx
	pop ebp
	ret


