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
	addi	$t1,$zero,22 #delay

outerLoop:	
	sub	$t0,$t0,$t0
	ble	$a0,$zero,delayEnd
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

	#BACKUP THE REGISTERS WE'RE GOING TO USE
	PUSH	$t8
	PUSH	$t7
	PUSH	$t6

	andi	$a1,$a1,0x0000ffff
	add	$t8,$zero,$a0 #COPY THE ADRESS
	addi	$t7,$zero,0 #STRING TO RETURN
	addi	$t6,$zero,0 #SECOND STRING TO RETURN
	add	$t5,$zero,$ra #save return adress
	
	
	
	#compute the third character
	srl	$a0,$a1,4 # shift so that we have the second digit last
	
	#before calling hexasc, backup t8 and t7 as it may change them
	PUSH	$t8
	PUSH	$t7
	PUSH	$t6
	jal	hexasc
	nop
	POP	$t6
	POP	$t7
	POP	$t8
	
	
	
	
	
	#append the third character
	sll	$t7,$t7,8	
	add	$t7,$t7,$v0 
	
	
	#append the colon
	sll	$t7,$t7,8	
	add	$t7,$t7,0x3A
	
	#compute the second character
	srl	$a0,$a1,8 # shift so that we have the second digit last
	#before calling hexasc, backup t8 and t7 as it may change them
	PUSH	$t8
	PUSH	$t7
	PUSH	$t6
	jal	hexasc
	nop
	POP	$t6
	POP	$t7
	POP	$t8
	
	
	#append the second character
	sll	$t7,$t7,8	
	add	$t7,$t7,$v0 

	#compute the first character
	srl	$a0,$a1,12 # shift so that we have the first digit last
	#before calling hexasc, backup t8 and t7 as it may change them
	PUSH	$t8
	PUSH	$t7
	PUSH	$t6
	jal	hexasc
	nop
	POP	$t6
	POP	$t7
	POP	$t8
		
	
	#append the first character
	sll	$t7,$t7,8
	add	$t7,$t7,$v0 
	
	
	##INTRODUCING NEW VARIABLE t6. t7 is now full and cant be used anymore
	
	#append the null character
	sll	$t6,$t6,8	
	add	$t6,$t6,0x00
	
	#compute the fourth character
	srl	$a0,$a1,0 # shift so that we have the second digit last
	#before calling hexasc, backup t8 and t7 as it may change them
	PUSH	$t8
	PUSH	$t7
	PUSH	$t6
	jal	hexasc
	nop
	POP	$t6
	POP	$t7
	POP	$t8
	
	
	#append the fourth character
	sll	$t6,$t6,8	
	add	$t6,$t6,$v0
	
	
	
	#WRITE BOTH REGISTERS TO MEMORY
	sw	$t7,0($t8)
	sw	$t6,4($t8)
	
	#RESTORE THE REGISTERS
	PUSH	$t6
	PUSH	$t7
	PUSH	$t8
	
	
	#GO BACK
	jr	$t5
	nop