global open

section .text
; -----------------------------------------------------------------------------
; open
; -----------------------------------------------------------------------------
; Takes file path and returns file descriptor for reading
;
; Input:
;   [ebp+8]  - filename
; Output: eax - file descriptor
;
; Registers used:
; -----------------------------------------------------------------------------
open:
	push	ebp
	mov	ebp, esp
	push	ebx

	; open file
	mov	eax, 5		; sys_open
	mov	ebx, [ebp+8]	; filename pointer
	mov	ecx, 02202o     ; O_RDWR | O_APPEND | O_CREAT
	mov	edx, 0644o      ; rw-r--r--
	int	0x80

	pop	ebx
	pop	ebp
	ret
