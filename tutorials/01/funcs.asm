section .data
	g:	dd	4	; setting g to its initial value

section .text
	global add_g
	global min

add_g:	
	push	ebp
	mov	ebp, esp
	mov	eax, [ebp+8]
	add	eax, [g]
	leave
	ret

min:
	push	ebp
	mov	ebp, esp
	mov	eax, [ebp+8]
	add	eax, [g]
	leave
	ret

