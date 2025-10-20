extern strcat
extern strcpy

global get_txt

section .data
	wall	db	"/wall.txt",0
	friends	db	"/friends.txt",0

section .text
; -----------------------------------------------------------------------------
; get_txt
; -----------------------------------------------------------------------------
; Addes the "/wall.txt\0" or "/friends.txt\0" to a given 
;
; Input:
;   [esp+8]   - filename
;   [exp+12]  - 0 for wall, 1 for friends
;   [esp+16]  - buffer
; Output: eax - pointer to the destination str null byte
;
; Registers used:
;   ecx - tmp
;   eax - return value / temp value
; -----------------------------------------------------------------------------
get_txt:
	push	ebp
	mov	ebp, esp

	push	dword [ebp+8]	; strcpy[1] = filename
	push	dword [ebp+16]	; strcpy[0] = buffer
	call	strcpy		; strcpy()
	add	esp, 8
	
	sub	eax, [ebp+16]	; term_buffer - buffer

	push	eax		; strcat[2] = destination str len

	mov	ecx, [ebp+12]	; file option
	test	ecx, ecx
	je	.wall
	push	friends		; strcat[1] = "/friends.txt\0"
	jmp	.friends
.wall:
	push	wall		; strcat[1] = "/wall.txt\0"
.friends:
	push	dword [ebp+16]	; strcat[0] = buffer
	call	strcat		; strcat()
	add	esp, 12

	pop ebp
	ret
