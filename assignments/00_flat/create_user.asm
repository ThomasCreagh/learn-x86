extern user_exists
extern get_txt
extern mkdir
extern touch
extern print

global	create_user

section .data
	nok	db	"nok: user already exists",10 , 0
	ok	db	"ok: user created!", 10, 0


section .bss
	buffer	resb	256

section .text
; -----------------------------------------------------------------------------
; create_user
; -----------------------------------------------------------------------------
; Create files for user init. a
;
; Input:
;   [ebp+8] - user id
; Output:
;   eax - sucessful or not
; -----------------------------------------------------------------------------
create_user:
	push	ebp
	mov	ebp, esp
	push	esi
	; save userid
	mov	esi, [ebp+8]

	; check user existance
	push	esi
	call	user_exists	; user_exists(argv[1])
	add	esp, 4		; clean stack
	
	test	eax, eax
	jnz	.not_exists	; if (file exists) {
	push	nok		;   exit[0] = nok
	call	print		;   print error
	add	esp, 4		;   clean stack
	mov	eax, 1		;   return val = 1
	jmp	.exit
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
	;mov	edi, buffer
	;mov	ecx, 32        ; 256 bytes / 4 bytes per store = 32
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
	pop	esi
	pop	ebp
	ret			; return
