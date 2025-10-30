extern add_friend
extern create_user
extern display_wall
extern post_message
extern read
extern print

global server

section .data
	nok			db	"nok: bad request",10 , 0

section .bss
	input_buffer		resb	512

section .text
; -----------------------------------------------------------------------------
; server
; -----------------------------------------------------------------------------
; Manages input and runs nessasry subroutines
;
; Input:
;   [ebp+8]  - user id
; Output:
;   eax - 0 sucessful or 1 not
;
; Registers used:
;   eax - return value / temporary
; -----------------------------------------------------------------------------
server:
	push	ebp
	mov	ebp, esp
	push	esi
	push	edi
	; save user id
	mov	esi, [ebp+8]

	; check user existance
	push	esi
	call	user_exists		; user_exists(userid)
	add	esp, 4			; clean stack
	
	test	eax, eax
	jz	.user_exists		; if (file exists) {
	push	nok			;   print[0] = nok
	call	print			;   print error
	add	esp, 4			;   clean stack
	mov	eax, 1			;   return val = 1
	jmp	.exit
.user_exists:
	; get wall.txt
	push	filename_buffer		; get_txt[2] = filename_buffer
	push	0			; get_txt[1] = 0	// wall file
	push	esi			; get_txt[0] = user id
	call	get_txt
	add	esp, 12			; clean stack
	
	; start_of_file
	push	start_of_file		;   print[0] = start_of_file
	call	print			;   print start
	add	esp, 4			;   clean stack

	; cat file
	push	filename_buffer		; cat->filename_buffer
	call	cat
	add	esp, 4			; clean stack

	; end_of_file
	push	end_of_file		;   print[0] = end_of_file
	call	print			;   print end
	add	esp, 4			;   clean stack

	xor	eax, eax
.exit:
	pop	edi
	pop	esi
	pop	ebp
	ret				; return
