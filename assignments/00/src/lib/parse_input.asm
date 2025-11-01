extern open
extern close
extern tokenize_str
extern strcmp

global parse_input

section .bss
	offset	resd	1      ; reserve 4 bytes (int)

section .text
; -----------------------------------------------------------------------------
; parse_input
; -----------------------------------------------------------------------------
; Parses stdin into an array of arguments
;
; Input:
;   [ebp+8]   - input_buffer
;   [ebp+12]  - token_array 
; Output: eax - 0 for false 1 for true, neg for error
;
; Registers used:
; -----------------------------------------------------------------------------
parse_input:
	push	ebp
	mov	ebp, esp
	push	ebx
	push	esi
	push	edi

	mov	esi, [ebp+12]		; token_array

	push	512			; read->size = 512
	push	dword [ebp+8]		; read->buffer = file buffer
	push	0			; read->file_descriptor = stdin
	call	read
	add	esp, 12			; clean stack

	mov	dword [offset], 0	; offset = 0
	mov	edi, 0			; token_array_index = 0

.loop:
	push	dword offset		; tokenize_str->offset
	push	[ebp+8]			; tokenize_str->buffer
	call	tokenize_str
	add	esp, 8			; clean stack
	test	eax, eax		; chekcing if bytes written is 0
	js	.return			; if negative, exit early with eax = error code
	jz	.end_of_input
	mov	[esi + edi*4], eax	; move address of token into array
	inc	edi			; index++
	jmp	.loop

.end_of_input:
	mov	eax, edi
	jmp	.return

.return:
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
	ret

