  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0,9 	# change this to test different values

	jal	hexasc		# call hexasc
	nop	# delay slot filler (just in case)	

return:
	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  #
  
hexasc: 
	li $t1,0x37 #hardcode the starting point from which we add letter values.
	slti $t0,$a0,10 #check if letter or number. true = number. $t0 is 0 if input >10
	beq $t0,$zero,isLetter #if letter fo to isLetter
	
	addi $v0,$a0,0x30 #if not letter start from position 0x30 and add a0 steps. 0x30 is 0.
	
	j	return    #return back
	
	isLetter: 
		add $v0, $t1, $a0 #if letter start from position 0x37 (t1) and add a0. if a0 is 10 we'll get A and so on
		j	return



 
