	.text
	.global starts_with
starts_with:
	# a0 = arg0
	lb	a0, 0(a0)	# load the fist byte of the string into the return register
	ret
