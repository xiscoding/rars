.data
	# Info messages
	end_message: .asciz "Your function was called successfully. Check the registers specified in the post-condition to verify correctness of your function."
	continue_message:  .asciz "\nPress any key to continue"
	# Test menu
	test_question:  .asciz "\nWhich program do you want to run? [0-1]\n"
	test_0: 	.asciz     "  0.  Linked list (Part 1)\n"
	test_1: 	.asciz     "  1.  Stack (Part 2)\n"

	# Stack prompts
	stack_one_prompt: .asciz "Enter the first positive integer: "
	stack_two_prompt: .asciz "Enter the second positive integer: "

	# Linked list creation
	create_message:    .asciz "Creating the linked list for testing your functions...\n"
	create_pad_prompt: .asciz "Enter a non-negative integer for padding words: "
	create_prompt:     .asciz "Enter a positive integer to insert into the linked list (-1 to end linked list creation): "

	# Function menu
	function_question: 	.asciz     "\nWhich function do you want to run? [0-4]\n"
	function_0: 	.asciz     "  0.  Count elements (LL_COUNT)\n"
	function_1: 	.asciz     "  1.  Search for an element (LL_SEARCH)\n"
	function_2: 	.asciz     "  2.  Get the element at index (LL_INDEX)\n"
	function_3: 	.asciz     "  3.  Get all elements greater or equal (LL_GREATER_OR_EQUAL)\n"
	function_4: 	.asciz     "  4.  Reverse linked list (LL_REVERSE)\n\n"
	exit_funct:	.asciz	   "  -1. Exit Program(QUIT)\n\n"
	invalid_input:  .asciz     "Invalid selection, try again."

	# Function prompts
	search_prompt: 	.asciz "Enter the integer to search for: "
	index_prompt: 	.asciz "Enter the index to retrieve: "
	greater_or_equal_prompt: .asciz "Enter the lower bound: "

	# Miscellanous
	prompt_char: .asciz "> "

.text
main:
TEST_SELECTION:
	# Display test
	la a0, test_question
	li a7, 4
	ecall
	la a0, test_0
	ecall
	la a0, test_1
	ecall
	la a0, prompt_char
	ecall

	# Read user selection
	li a7, 5
	ecall

	# Validate that it's between 0-1 inclusive
	blt a0, zero, INVALID_TEST
	li t0, 1
	bgt a0, t0, INVALID_TEST
	j VALID_TEST

INVALID_TEST:
	la a0, invalid_input
	li a7, 4
	ecall
	j TEST_SELECTION

VALID_TEST:
	# Switch on user selection
	beq a0, zero, TEST_LINKED_LIST
	# Fall through to stack test
TEST_STACK:
	# Place first integer into t0
	la a0, stack_one_prompt
	li a7, 4
	ecall

	li a7, 5
	ecall

	add s0, a0, zero

	# Place second integer into t1
	la a0, stack_two_prompt
	li a7, 4
	ecall

	li a7, 5
	ecall

	add s1, a0, zero

	# Load arguments and call stack code
	add a0, s0, zero
	add a1, s1, zero
	jal ra, PROC_GREATER_DIGIT_SUM

	j EXIT
TEST_LINKED_LIST:
	# Allocate and initialize sentinel node
	li a0, 8 		# Allocate 8 bytes on the heap
	li a7, 9 		# Sbrk syscall
	ecall  			# a0 now contains the address of the allocated sentinel node

	sw zero, (a0) 		# a0->data = 0
	sw zero, 4(a0) 		# a0->next = 0
	add s1, a0, zero 	# head = a0
	add s2, a0, zero 	# sentinel = a0

	# Display create message to user
	la a0, create_message
	li a7, 4
	ecall
CREATE_LIST:
	# Display padding prompt to user
	la a0, create_pad_prompt
	li a7, 4
	ecall

	# Read integer from user
	li a7, 5
	ecall

	# Ensure 4-byte alignment
	slli a0, a0, 2

	# Call sbrk with the given padding
	li a7, 9
	ecall

	# Display value prompt to user
	la a0, create_prompt
	li a7, 4
	ecall

	# Read integer from user
	li a7, 5
	ecall

	# Exit if integer read is less than 0
	blt a0, zero, FUNCTION_SELECTION

	# Otherwise add the integer to the linked list
	add a1, a0, zero 	# Argument 2: Data to add to the node
	add a0, s1, zero 	# Argument 1: Head of linked list
	jal ra, LL_PUSH_FRONT

	add s1, a0, zero 	# Update head of linked list

	j CREATE_LIST

FUNCTION_SELECTION:
	# Display function
	la a0, function_question
	li a7, 4
	ecall
	la a0, function_0
	ecall
	la a0, function_1
	ecall
	la a0, function_2
	ecall
	la a0, function_3
	ecall
	la a0, function_4
	ecall
	la a0, exit_funct
	ecall
	la a0, prompt_char
	ecall
	
	# Read user selection
	li a7, 5
	ecall

	# Validate that it's between 0-4 inclusive
	#blt a0, zero, INVALID_FUNCTION	
	blt a0, zero, EXIT
	li t0, 4
	bgt a0, t0, INVALID_FUNCTION
	j VALID_FUNCTION

INVALID_FUNCTION:
	la a0, invalid_input
	li a7, 4
	ecall
	j FUNCTION_SELECTION

VALID_FUNCTION:
	# Switch on user selection
	beq a0, zero, COUNT_LIST
	li t0, 1
	beq a0, t0, SEARCH_LIST
	li t0, 2
	beq a0, t0, INDEX_LIST
	li t0, 3
	beq a0, t0, GREATER_OR_EQUAL_LIST
	li t0, 4
	beq a0, t0, REVERSE_LIST
	


COUNT_LIST:
	add a0, s1, zero
	jal ra, LL_COUNT
	j END


SEARCH_LIST:
	la a0, search_prompt
	li a7, 4
	ecall

	li a7, 5
	ecall

	add a1, a0, zero
	add a0, s1, zero
	jal ra, LL_SEARCH

	j END


INDEX_LIST:
	la a0, index_prompt
	li a7, 4
	ecall

	li a7, 5
	ecall

	add a1, a0, zero
	add a0, s1, zero
	jal ra, LL_INDEX

	j END


GREATER_OR_EQUAL_LIST:
	la a0, greater_or_equal_prompt
	li a7, 4
	ecall

	li a7, 5
	ecall

	add a1, a0, zero
	add a0, s1, zero
	jal ra, LL_GREATER_OR_EQUAL

	j END

REVERSE_LIST:
	add a0, s1, zero
	add a1, s2, zero
	jal ra, LL_REVERSE
	add s1, a0, zero
	j END

END:
	# Save a0 to avoid clobbering the return value of the functions called
	add t0, a0, zero
	# Restore a0
	add a0, t0, zero
	# Display end message to user
	la a0, end_message
	li a7, 4
	ecall
	la a0, continue_message
	li a7, 4
	ecall
	# Read integer from user
	li a7, 12
	ecall
	j EXIT
	
EXIT:
	# Quit
	li a7, 10
	ecall
