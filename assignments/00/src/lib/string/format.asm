extern strcpy

global format

section .text
; -----------------------------------------------------------------------------
; format
; -----------------------------------------------------------------------------
; Formats string with $ and given vars
;
; Input:
;   [ebp+8]  - destination buffer
;   [ebp+12] - source buffer
;   [ebp+16] - input 1
;   ...
;   [ebp+(N*4)+16] - input N
; Output: eax - number of replaced $
; -----------------------------------------------------------------------------
format:
	push	ebp
	mov	ebp, esp
	push	esi
	push	edi
	push	ebx
	mov	ebx, 16		; move to the first input

	mov	edi, [ebp+8]	; dest = arg[0]
	mov	esi, [ebp+12]	; source = arg[1]
.loop:
	lodsb			; tmp = source[index++]
	cmp	al, '$'
	je	.replace
	stosb			; dest[index++] = tmp
	test	al, al
	jnz	.loop

	jmp	.return

.replace:
	push	[ebp+ebx]	; push source
	push	edi		; push dest
	call	strcpy	
	add	esp, 8		; clean stack
	mov	edi, eax	; mov dest to end of cpy dest
	add	ebx, 4		; mov to next input
	jmp	.loop

.return:
	pop	ebx
	pop	edi
	pop	esi
	pop	ebp
	ret
