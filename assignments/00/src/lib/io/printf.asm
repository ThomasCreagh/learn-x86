extern strcpy
extern print

global printf

section .bss
	buffer	resb	256

section .text
; -----------------------------------------------------------------------------
; printf
; -----------------------------------------------------------------------------
; prints null terminating string with given inputs
;
; Input:
;   [ebp+8] - message
;   [ebp+12] - input 1
;   ...
;   [ebp+(N*4)+12] - input N
; Output:
;   eax - sys print return call
; -----------------------------------------------------------------------------
printf:
	push	ebp
	mov	ebp, esp	
	push	esi
	push	edi
	push	ebx
	mov	ebx, 12		; move to the first input

	mov	edi, buffer	; dest = arg[0]
	mov	esi, [ebp+8]	; source = arg[1]
.loop:
	lodsb			; tmp = source[index++]
	cmp	al, '$'
	je	.replace
	stosb			; dest[index++] = tmp
	test	al, al
	jnz	.loop

	jmp	.print

.replace:
	push	dword [ebp+ebx]	; push source
	push	edi		; push dest
	call	strcpy	
	add	esp, 8		; clean stack
	mov	edi, eax	; mov dest to end of cpy dest
	add	ebx, 4		; mov to next input
	jmp	.loop

.print:
	push	buffer
	call	print
	add	esp, 4

	pop	ebx
	pop	edi
	pop	esi
	pop	ebp
	ret

