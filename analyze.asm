  # analyze.asm
  # This file written 2015 by F Lundevall
  # Modified and improved by Ivan Liljeqvist and Filip Martinsson
  # Copyright abandoned - this file is in the public domain.

	.text
main:
	li	$s0,0x30
loop:
	move	$a0,$s0		# copy from s0 to a0
	
	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window

	addi	$s0,$s0,3	#CHANGED: increase the step
	
	li	$t0,0x5d	#CHANGED: change loop condition from 5b (91) to 5d(93) to match the step 3. 93%3=0
	bne	$s0,$t0,loop
	nop			# delay slot filler (just in case)

stop:	j	stop		# loop forever here
	nop			# delay slot filler (just in case)
	
	

# Consider the large loop in the the original program – from the label loop to the branch bne loop. How many iterations are executed in this loop?
# The loop has 14 iterations. $s0 starts at 48 (0x30) and stops at 93 (0x5d) increasing with step 3. 
# (93-48)/3=15. The last one isn't printed. So 15-1=14