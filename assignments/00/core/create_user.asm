extern user_exists
extern get_txt
extern mkdir
extern touch

global	create_user

section .data
	nok	db	"nok: user already exists", 0
	ok	db	"ok: user created!", 0


section .bss
	buffer	resb	128

section .text
; -----------------------------------------------------------------------------
; create_user
; -----------------------------------------------------------------------------
; Create files for user init.
;
; Input:
;   [esp+8] - user id
; Output:
;   eax - sucessful or not
;   edx - output message
;
; Registers used:
;   eax - return value / temporary
; -----------------------------------------------------------------------------
create_user:
	push	ebp
	mov	ebp, esp
	; save userid
	mov	esi, [esp+8]

	; check user existance
	push	esi
	call	user_exists	; user_exists(argv[1])
	add	esp, 4		; clean stack
	
	test	eax, eax
	jnz	.not_exists	; if (file exists) {
	mov	edx, 1		;   exit[1] = 1
	mov	eax, nok	;   exit[0] = nok
	pop	ebp
	ret			; return
.not_exists:
	; check if data file exists

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
	mov	edx, 0		;   exit[1] = 0
	mov	eax, ok	;   exit[0] = ok
	pop	ebp
	ret			; return
