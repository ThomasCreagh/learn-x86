extern read

global user_in_file

section .bss
	buffer	resb	12

section .text
; -----------------------------------------------------------------------------
; user_in_file
; -----------------------------------------------------------------------------
; Reads the full contents of a file
;
; Input:
;   [ebp+8]   - filename
; Output: eax - bytes read or neg errors
;
; Registers used:
; -----------------------------------------------------------------------------
read:
	push	ebp
	mov	ebp, esp
	push	ebx
	push	esi
	push	edi

	mov	esi, [ebp+8]

	; open file
	mov	eax, 5		; sys_open
	mov	ebx, esi	; filename pointer
	mov	ecx, 0000o	; flags: O_RDONLY
	int	0x80

	cmp	eax, 0
	js	.return		; if error (eax < 0)

	mov	esi, eax	; save file descriptor

	; get file size
	mov	eax, 19		; sys_lseek
	mov	ebx, esi	; file descriptor
	xor	ecx, ecx	; offset = 0
	mov	edx, 2		; SEEK_END = 2
	int	0x80

	mov	edi, eax	; size = return value

	; reset file descriptor to start
	mov	eax, 19		; sys_lseek
	mov	ebx, esi	; file descriptor
	xor	ecx, ecx	; offset = 0
	mov	edx, 0		; SEEK_SET =0 
	int	0x80

	; read entire file to buffer
	mov	eax, 3		; sys_read
	mov	ebx, esi	; file descriptor
	mov	ecx, [ebp+12]	; buffer
	mov	edx, edi	; size
	int	0x80

	mov	edi, eax	; read bytes

	; close file
	mov	eax, 6 ; sys_close
	mov	ebx, esi
	int	0x80

	mov	eax, edi

.return:
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
	ret
