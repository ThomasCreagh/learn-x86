	.text
	.globl add # Make 'add' visible to the linker

# Arguments come from the caller (a0=x10, a1=x11)
add:
	#compute
	add	a0, a0, a1
	#return
	ret

