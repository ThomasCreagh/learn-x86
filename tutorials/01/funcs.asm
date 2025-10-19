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
	mov	eax, [ebp+8]	; get a
	mov	edx, [ebp+12]	; get b
	cmp	eax, edx	; is a < b
	jl	.min_fst
	mov	eax, edx	; replace a with the value in b
.min_fst:
	mov	edx, [ebp+16]	; get c
	cmp	eax, edx	; is min(a, b) < c
	jl	.min_snd
	mov	eax, edx	; replace a with the value in b
.min_snd:
	leave
	ret

