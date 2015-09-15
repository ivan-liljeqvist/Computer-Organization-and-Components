# timetemplate.asm
  # Written 2015 by F Lundevall
  # Ivan Liljeqvist and Filip Martinsson
  # Copyright abandonded - this file is in the public domain.

.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
main:
	# print timstr
	la	$a0,timstr
	li	$v0,4
	syscall
	nop
	# wait a little
	li	$a0 1000
	jal	delay
	nop
	# call tick
	la	$a0,mytime
	jal	tick
	nop
	# call your function time2string
	la	$a0,timstr
	la	$t0,mytime
	lw	$a1,0($t0)
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result
	jr	$ra		# return
	nop

hexasc:
	andi	$v0, $a0, 0xf	   #Mask so that we ignore everything except the last 4 bits (F is 4 bits at the end) 
	addi	$v0, $v0, 0x30	   #Add the start value of ASCII table
	
	addi 	$t1, $zero,  0x3a  #Threshold between numbers and characters
	slt	$t2, $v0,$t1	   #Decide if letter or character
	
	bne 	$t2, 1, letter
	nop
	jr	$ra
	nop
	
letter:
	addi	$v0,$v0,7	  #If letter - jump 7 steps more to match where the letters are in the table
	jr	$ra
	nop
		
delay: 
	PUSH $t0
	PUSH $t1
	
	addi	$t0,$zero,0 #i 
	addi	$t1,$zero,700 #delay

outerLoop:	
	sub	$t0,$t0,$t0 #set i to 0
	ble	$a0,$zero,delayEnd #check id a0 is less than zero
	nop
	subi	$a0,$a0,1
innerLoop:
		addi	$t0,$t0,1
		bne	$t0,$t1,innerLoop #less than delay constant, keep loop
		nop
		j	outerLoop
		nop
	
delayEnd:
	POP $t1
	POP $t0
	
	jr $ra
	nop


time2string:

	PUSH $s7
	PUSH $s6
	PUSH $s5
	PUSH $s4
	PUSH $s3
	PUSH $s2


	andi	$a1,$a1,0x0000ffff
	add	$s7,$zero,$a0 #COPY THE ADRESS
	addi	$s6,$zero,0 #STRING TO RETURN
	addi	$s5,$zero,0 #SECOND STRING TO RETURN
	add	$s4,$zero,$ra #save return adress
	
	
	
	#compute the third character
	srl	$a0,$a1,4 # shift so that we have the second digit last
	
	

	jal	hexasc
	nop

	
	
	
	
	
	#append the third character
	sll	$s6,$s6,8	
	add	$s6,$s6,$v0 
	
	
	#append the colon
	sll	$s6,$s6,8	
	add	$s6,$s6,0x3A
	
	#compute the second character
	srl	$a0,$a1,8 # shift so that we have the second digit last
	
	jal	hexasc
	nop
	
	
	#append the second character
	sll	$s6,$s6,8	
	add	$s6,$s6,$v0 

	#compute the first character
	srl	$a0,$a1,12 # shift so that we have the first digit last

	jal	hexasc
	nop

	
	#append the first character
	sll	$s6,$s6,8
	add	$s6,$s6,$v0 
	
	
	##INTRODUCING NEW VARIABLE s5. s6 is now full and cant be used anymore
	
	#append the null character
	sll	$s5,$s5,8	
	add	$s5,$s5,0x00	
	
	#compute the fourth character
	srl	$a0,$a1,0 # shift so that we have the second digit last
	
	addi	$s3,$zero,2 #to compare if the input is 2
	add	$s2,$zero,$a0 #save a0 value, if it's f.ex. 12 we need to mask away the 1
	andi	$s2,$s2,0x0000000f #mask
	
	beq	$s2,$s3,characterTwo
	nop
	

	jal	hexasc
	nop

	
	
	#append the fourth character
	sll	$s5,$s5,8	
	add	$s5,$s5,$v0
	
	
	characterTwoReturn:
	
	
	#WRITE BOTH REGISTERS TO MEMORY
	sw	$s6,0($s7)
	sw	$s5,4($s7)
	
	POP $s2
	POP $s3
	POP $s5
	POP $s6
	POP $s7
	
	#GO BACK
	jr  $s4
	POP $s4	#we cant pop before jumping

	characterTwo:
	sll	$s5,$s5,8	
	add	$s5,$s5,0x4f #APPEND O
	sll	$s5,$s5,8	
	add	$s5,$s5,0x57 #APPEND W
	sll	$s5,$s5,8	
	add	$s5,$s5,0x54 #APPEND T
	j	characterTwoReturn
	nop
	

#Q: no result in v0, it writes to memory insted
#Q: yes, to save and reset registers
#Q: store in the temporary registers. $t0, †1
#Q: we can't write to memory that is not aligned, the program will crash

#When 0 - delay, outerLoop, innerLoop and then back to outerLoop. It's not less than 0
#when 2 - delay, outerLoop, innerLoop and then back to outerLoop three times. 2,1,0
#when -1 - delay, outerLoop (ble) - jump to delayEnd. Roughly 0
