  
  #FRÅGA: varför så många bitar? Binary? Är vår fel??
  #FRÅGA: Finns väl bara 1 svar till fråga 3?
  
  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.

	.text
main:
	li	$a0,1	# change this to test different values

	jal	hexasc		# call hexasc
	nop	# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)


  
hexasc:
	andi	$v0, $a0, 0x00000F #Mask so that we ignore everything except the last 4 bits (F is 4 bits at the end) 
	addi	$v0, $v0, 0x30	   #Add the start value of ASCII table
	
	addi 	$t1, $zero,  0x3A  #Threshold between numbers and characters
	slt	$t2, $v0,$t1	   #Decide if letter or character
	
	bne 	$t2, 1, letter
	jr	$ra
	
letter:
	addi	$v0,$v0,7	  #If letter - jump 7 steps more to match where the letters are in the table
	jr	$ra
	
	
		

#Q: Assume that your subroutine hexasc is called with the integer-value 5 as the argument in register $a0. 
#Go through each code-line just as the processor would do when executing the program. For each code line, why is that code-line necessary?


#Q: Repeat the previous question for argument values 14 and 17.

#Q: The subroutine returns a 32-bit value in register $v0. Consider a case where the value returned is 0000 0000 0000 0000 0000 0000 0100 0001. 
#Try to calculate what the argument value in $a0 must have been when the subroutine was called. Is there exactly one possible value, 
#or more than one possible value, or no possible value? If more than one value was possible, state at least two such values.

#A: 0000 0000 0000 0000 0000 0000 0100 0001 = 65
# 65 in hex is 0x41
# 0x41 corresponds to 'A'
# to get 'A' you have to input 10



 
