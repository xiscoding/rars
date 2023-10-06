.data
.text

.globl PROC_GREATER_DIGIT_SUM
.globl PROC_ADD_DIGITS

# -----------------------------------------------------------------------------
# Given two positive integers, return the integer with the greater digit sum.
# The digit sum of an integer is the sum of its digits, ie.
# digit_sum(432) == 9
# If they have equal digit sums, return -1
#
# Pre:
# 	- $a0 contains the first positive integer
# 	- $a1 contains the second positive integer
# Post:
# 	- $a0 contains the integer with the greater digit sum
# -----------------------------------------------------------------------------
PROC_GREATER_DIGIT_SUM:
	# -- START EDITING HERE --
	#callee - saved s0,s1
	#PROC_ADD_DIGITS - caller saved t0
	addi sp,sp, -16 #allocate mem for two ints (8 bytes above the stack)
	sw s0, 8(sp) #save s0
	sw s1, 4(sp) #save s1
	sw ra, 0(sp)
	
	
	# -- END EDITING HERE --

	addi 	s0, a0, 0 		# Save the first integer
	addi 	s1, a1, 0 		# Save the second integer

	# Sum digits of first integer and save to t0
	addi 	a0, s0, 0
	jal 	ra, PROC_ADD_DIGITS
	addi 	t0, a0, 0

	# -- START EDITING HERE --
	#allocate mem for one int (4 bytes above stack)
	sw t0, 12(sp) #save t0 
	# -- END EDITING HERE --

	# Sum digits of second integer and save to t1
	addi 	a0, s1, 0
	jal 	ra, PROC_ADD_DIGITS
	addi 	t1, a0, 0

	# -- START EDITING HERE --
	lw t0, 12(sp)
	 #allocate mem for one int (4 bytes above stack)
	# -- END EDITING HERE --

	# Assume the first integer has the greater digit sum
	addi 	a0, s0, 0

	# Check our assumption
	beq 	t0, t1, PROC_GDS_EQUAL
	blt 	t0, t1, PROC_GDS_SECOND_INTEGER_GREATER
	j 	PROC_GDS_EXIT

	PROC_GDS_EQUAL:
		li 	a0, -1
		j 	PROC_GDS_EXIT

	PROC_GDS_SECOND_INTEGER_GREATER:
		addi 	a0, s1, 0

	PROC_GDS_EXIT:

	# -- START EDITING HERE --
	# 16 bytes allocated t1, t0, s0, s1	
	lw ra, 0(sp)
	lw s1, 4(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	# -- END EDITING HERE --

	jr 	ra, 0

# -----------------------------------------------------------------------------
# Given a positive integer, return the sum of its digits.
#
# Pre:
# 	- $a0 contains the positive integer
# Post:
# 	- $a0 contains the integer's digit sum
# -----------------------------------------------------------------------------
PROC_ADD_DIGITS:
	li 	t0, 0 		# Accumulator
	li 	t1, 10 		# Constant 10 for divrem
	li 	t2, 0 		# Temporary to store rem result

	PROC_AD_LOOP:
		rem 	t2, a0, t1 
		add 	t0, t0, t2
		ble 	a0, t1, PROC_AD_EXIT
		div 	a0, a0, t1
		j 	PROC_AD_LOOP

	PROC_AD_EXIT:
		addi 	a0, t0, 0
		jr 	ra, 0  #JUMPS TO START OF STACK.ASM
