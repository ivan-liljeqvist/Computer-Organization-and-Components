  # timetemplate.asm
  # Written 2015 by F Lundevall
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
	li	$a0,2
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

  # you can write your code for subroutine "hexasc" below this line
  #
  

hexasc:
	andi	$v0, $a0, 0x00000f #Mask so that we ignore everything except the last 4 bits (F is 4 bits at the end) 
	addi	$v0, $v0, 0x30	   #Add the start value of ASCII table
	
	addi 	$t1, $zero,  0x3a  #Threshold between numbers and characters
	slt	$t2, $v0,$t1	   #Decide if letter or character
	
	bne 	$t2, 1, letter
	j	return
	
letter:
	addi	$v0,$v0,7	  #If letter - jump 7 steps more to match where the letters are in the table
	j	return

		
delay: jr $ra
nop


time2string:
	andi	$a1,$a1,0x0000fffff
	addi	$t9,$zero,3 #counter to decide how many steps to shift
	addi	$t7,$zero,2 #point at which we should add a colon
	addi	$t6,$zero,4 #number of iterations left
return:

	beq	$t6,$zero, end
	srlv	$a0,$a1,$t9
	subi	$t9,$t9,1 #lower shift counter
	subi	$t6,$t6,1 #lower interations counter
	
	beq	$t9,$t7,addColon #add color when we're in the middle
	
	sll	$t8,$t8,4 #make room for next letter by shifting left
	add	$t8,$t8,$v0 #add letter
	
	jal	hexasc	
	
		
	nop	
	

	addColon:
	#add colon to the string
	sll	$t8,$t8,4 #make room for next letter by shifting left
	addi	$t8,$t8,0x3A
	
	end:
	#add null to the string and write to memory
	#add NULL to the string
	sll	$t8,$t8,4 #make room for next letter by shifting left
	addi	$t8,$t8,0x00
	sw 	$t8,($a0)
	
	
	
	
		
