extern user_exists
extern get_txt
extern print
extern printf
extern cat

global display_wall

section .data
	nok			db	"nok: user $ does not exist", 10 , 0	; id
	start_of_file		db	"start_of_file", 10, 0
	end_of_file		db	"end_of_file", 10, 0

section .bss
	filename_buffer		resb	256

section .text
; -----------------------------------------------------------------------------
; display_wall
; -----------------------------------------------------------------------------
; Displays the entire wall of a given user
;
; Input:
;   [ebp+8]  - user id
; Output:
;   eax - 0 sucessful or 1 not
; -----------------------------------------------------------------------------
display_wall:
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
	push	esi			;   print[1] = $user
	push	nok			;   print[0] = nok
	call	printf			;   printf error
	add	esp, 8			;   clean stack
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
