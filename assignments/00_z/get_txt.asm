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
;   [ebp+8]   - filename
;   [ebp+12]  - 0 for wall, 1 for friends
;   [ebp+16]  - buffer
; Output: eax - pointer to the destination str null byte
; -----------------------------------------------------------------------------
get_txt:
	push	ebp
	mov	ebp, esp
	push	esi
	push	edi

	push	dword [ebp+8]	; strcpy[1] = filename
	push	dword [ebp+16]	; strcpy[0] = buffer
	call	strcpy		; strcpy()
	add	esp, 8
	
	sub	eax, [ebp+16]	; term_buffer - buffer

	mov	esi, eax	; len = destination str len

	mov	ecx, [ebp+12]	; file option
	test	ecx, ecx
	je	.wall
	mov	edi, friends	; file_extention = "/friends.txt\0"
	jmp	.friends
.wall:
	mov	edi, wall	; file_extention = "/wall.txt\0"
.friends:
	push	esi		; strcat[2] = len
	push	edi		; strcat[1] = source (wall or friend)
	push	dword [ebp+16]	; strcat[0] = destination (filename buffer)
	call	strcat		; strcat()
	add	esp, 12

	pop	edi
	pop	esi
	pop ebp
	ret
