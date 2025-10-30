global open

section .text
; -----------------------------------------------------------------------------
; open
; -----------------------------------------------------------------------------
; Takes file path and returns file descriptor for reading
;
; Input:
;   [ebp+8]  - filename
;   [ebp+12] - open type (0 = read, 1 = write, 2 = append)
; Output: eax - file descriptor
;
; Registers used:
; -----------------------------------------------------------------------------
open:
	push	ebp
	mov	ebp, esp
	push	ebx

	mov	ecx, [ebp+12]	; open type
	cmp	ecx, 2
	je	.append		; type = append
	cmp	ecx, 1
	je	.write

; .read
	mov	eax, 5
	mov	ebx, [ebp+8]
	mov	ecx, 0		; O_RDONLY
	mov	edx, 0664o	; -rw-r--r--
	int	0x80
	jmp	.done

.write:
	mov	eax, 5
	mov	ebx, [ebp+8]
	mov	ecx, 01101o	; O_WRONLY | O_CREAT | O_TRUNC
	mov	edx, 0664o	; -rw-r--r--
	int	0x80
	jmp	.done

.append:
	mov	eax, 5
	mov	ebx, [ebp+8]
	mov	ecx, 02001o	; O_WRONLY | O_APPEND
	mov	edx, 0644o	; -rw-r--r--
	int	0x80

.done:
	pop	ebx
	pop	ebp
	ret
