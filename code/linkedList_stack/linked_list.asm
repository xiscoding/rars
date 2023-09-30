.data
.text

.globl LL_PUSH_FRONT
.globl LL_COUNT
.globl LL_SEARCH
.globl LL_INDEX
.globl LL_GREATER_OR_EQUAL
.globl LL_REVERSE

# -----------------------------------------------------------------------------
# Push a integer to the front of the given linked list.
# Allocates memory for the linked list node on the heap.
#
# Pre:
# 	- $a0 contains the address of the start of the linked list
# 	- $a1 contains the integer to add to the node
# Post:
# 	- $a0 contains the new address of the start of the linked list
# -----------------------------------------------------------------------------
LL_PUSH_FRONT:
	# -- START SOLUTION --
	#1. Allocate Memory for new node
	addi a0, x0, 8 #load 8 bytes
	li a7, 9 #sbrk syscall
	ecall 
	#2. Store Integer Value
	sw a1, 0(a0) #store integer value
	sw s1, 4(a0)
	addi s1, a0, 0
	# -- END SOLUTION --
	jr ra, 0


# -----------------------------------------------------------------------------
# Return the length of the given linked list.
# The length of the linked list is the number of nodes it contains.
# A list with only the sentinel node has length 0.
#
# Pre:
# 	- $a0 contains the address of the head of the linked list
# Post:
# 	- $a0 contains the length of the linked list
# -----------------------------------------------------------------------------
LL_COUNT:
	# -- START SOLUTION --
	#1. Initialize Counter
	li t0, 0
	#2. Start Traversal
	addi t1, s1, 0
	#3. INcrement Counter and Traversal Loop
	Loop_start:
		beq t1, x0, Loop_end	#beqz t1, Loop_end
		#Check if sentinal
		lw t2, 4(t1) #load the next pointer in t2
		beq t2, x0 Loop_end #check if pointer is 0
		addi t0, t0, 1
		lw t1, 4(t1) 
		j Loop_start
	Loop_end:
	#4. Return count 
	addi a0, t0, 0 #mv a0, t0
	# -- END SOLUTION --
	jr ra, 0


# -----------------------------------------------------------------------------
# Return the lowest index of the given integer in the list.
# Return -1 if the integer is not found.
#
# Pre:
# 	- $a0 contains the address of the head of the linked list
# 	- $a1 contains the integer to search for in the list
# Post:
# 	- $a0 contains the lowest index of the integer if found, -1 otherwise
# -----------------------------------------------------------------------------
LL_SEARCH:
	# -- START SOLUTION --
	#1. Initialize index counter
	li t0, 0
	#2. start traversal 
		#move head node address from s1 into t1 
	addi t1, s1, 0 #mv t1, s1
	#3. Start Compare and Traverse Loop
	Search_loop:
		beq t1, x0, Search_end #If t1 is zero (null pointer), jump to Search_end
		lw t2, 0(t1) #Load the integer value stored at the node into t2
		beq t2, a1, Search_found #If t2 equals the target value in a1, jump to Search_found
		addi t0, t0, 1 #Increment the index counter
		lw t1, 4(t1) #Load the next node's address into t1
		j Search_loop #Jump back to the start of the loop
	#Return search results [t0 (value t0 founc) | -1 (value not found)
	Search_found:
		#mv a0, t0
		addi a0, t0, 0 #move index (found value) from t0 to a0 for returning
		j Search_exit
	Search_end:
		li a0, -1 #Search not found
	Search_exit:
	# -- END SOLUTION --
	jr ra, 0


# -----------------------------------------------------------------------------
# Return the integer at the given index in the list, and an integer indicating
# success/failure.
# 
# The first integer is at index 0, second integer at index 1, and so forth.
# The index is invalid if it is greater or equal to the length of the list.
#
# Pre:
# 	- $a0 contains the address of the start of the linked list
# 	- $a1 contains the index of the list to retrieve
# 	- The index given is greater or equal to 0
# Post:
# 	- $a0 contains the integer at the given index if it is valid
# 	- $a1 contains 0 on success, or -1 on failure (if the index is invalid)
# -----------------------------------------------------------------------------
LL_INDEX:
	# -- START SOLUTION --
	#1. Initialize Index Counter
	li t0, 0
	#2. Start Traversal
	addi t1, s1, 0
	#3. Compare Index and Traversal Loop
	Index_loop:
		beq t1, x0, Index_end #If the node is 0 (null pointer), loop over
		beq t0, a1, Index_found #If t0 (current index) matches a1 (target index), jump to Index_found.
		addi t0, t0, 1 #Increment index counter
		lw t1, 4(t1) #load next node address into t1
		j Index_loop #Jump to start of loop
	Index_found:
		#check if sentinal node
		lw t2, 4(t1) #load the next pointer in t2
		beq t2, x0 Index_end #check if pointer is 0
		lw a0, 0(t1) #load the node value into a0
		li a1, 0 #load 0 into a1 SUCCESS
		j Index_exit #exit
	Index_end:
		li a0, -1 #load -1 into a0 (INVALID INDEX)
		li a1, -1 #load -1 into a1 FAILURE
	Index_exit:
	# -- END SOLUTION --
	jr ra, 0


# -----------------------------------------------------------------------------
# Return a heap-allocated array of all integers in the given linked list that
# are greater or equal to the given lower bound.
#
# If none of the integers in the linked list are greater or equal to the lower
# bound, return 0 for both the result array and its length.
# 
# Example 1:
# 	- (argument) Linked list: 1->5->3->7->4->9
# 	- (argument) Lower bound: 4
# 	- Values in result array on heap: 5, 7, 4, 9
# 	- (return value) Array pointer: 0x100040
# 	- (return value) Array length: 4
#
# Example 2:
# 	- (argument) Linked list: 1->5->3->7->4->9
# 	- (argument) Lower bound: 100
# 	- (return value) Array pointer: 0
# 	- (return value) Array length: 0
#
# Pre:
# 	- $a0 contains the address of the head of the linked list
# 	- $a1 contains the lower bound of the integers to retrieve
# Post:
# 	- $a0 contains the address of the heap-allocated result array
# 	- $a1 contains the length of the result array
# -----------------------------------------------------------------------------
LL_GREATER_OR_EQUAL:
	# -- START SOLUTION --
	#1. Initialize Counter and Array Length
	li t0, 0 #counter for nodes with values greater or equal to lower bound
	li t2, 0 #will store length of heap-allocated array
	#2. First Traversal 
	#mv t1, s1
	addi t1, s1, 0 #Move head node's address from s1 to t1 for traversal
	Count_loop:
		beq t1, x0, Allocate_memory #If t1 is zero (null pointer), jump to Allocate_memory
		lw t3, 0(t1) #Load the integer value from the node into t3
		blt t3, a1, Skip_increment #If the value in t3 is less than a1 (the lower bound), skip incrementing the counter
		addi t0, t0, 1 #Increment the counter
	Skip_increment:
		lw t1, 4(t1) #Load the next node's address into t1
		j Count_loop #Jump back to start to the loop
	Allocate_memory:
		beqz t0, No_elements #If t0 is zero, jump to No_elements
		slli t2, t0, 2 #Calculate the number of bytes needed for the array store in t2
		#start sbrk syscall
		mv a0, t2 #move length (t2) into a0 
		li a7, 9 # load ecall code 9 into a7
		ecall
	#4. Second Traversal and Array Population
		addi t1, s1, 0 #Reset t1 to the head node for second traversal
		li t4, 0 #Initialize an index t4 to zero for array population
		mv t5, a0
	Populate_loop:
		beq t1, x0, Finish #If t1 is zero, jump to Finish
		lw t3, 0(t1) #Load the integer value from the node into t3
		blt t3, a1, Skip_store #If the value in t3 is less than a1, skip storing it in the array
		sw t3, 0(a0) #Store the value at the current index of the array
		addi t4, t4, 1
		addi a0, a0, 4 #Increment the array address by 4 bytes
	Skip_store:
		lw t1, 4(t1) #Load the next node's address into t1
		j Populate_loop #Jump back to the start of the loop
	#5. Return Array and Length
	Finish: 
		mv a0, t5 #Move the array length into a0
		mv a1, t4 #Move the array address into a1
		j EXIT
	No_elements: 
		li a0, 0 #Load 0 into a0 to indicate no elements were found
		li a1, 0 #Load 0 into a1 to indicate an array length of zero 
	# -- END SOLUTION --
	EXIT:
		jr ra, 0
# -----------------------------------------------------------------------------
# Reverse the given linked list in-place, then return the new head of the
# linked list.
#
# Pre:
# 	- $a0 contains the address of the head of the linked list
#       - $a1 contains the address of sentinel value of the linked list
# Post:
# 	- $a0 contains the new address of the head of the linked list
# -----------------------------------------------------------------------------
LL_REVERSE:
	# -- START SOLUTION --
	#1. Initialize Pointers (old/new)
	addi t0, a1, 0 #store sentinal node in t0 ('previous'/'next')
	addi t1, a0, 0 #store head of linked list in t1 ('current'/'previous')
	#2. Start Traversal and Reversal
	Reverse_loop:
		lw t2, 4(t1) #Load the 'next' node address into temporary register t2
		beq t2, x0, Update_head #If t1 is zero (null pointer), jump to Update_head
		sw t0, 4(t1) #Store the 'previous' node address into the 'next' field of the 'current' node
		addi t0, t1, 0 #Update the 'previous' pointer to point to the 'current' node
		addi t1, t2, 0 #Move to the next node by updating the 'current' pointer
		j Reverse_loop
	#3. Update Head
	Update_head:
		addi a0, t0, 0 #Update the head pointer a0 to point to t0 (the old last non sentinel/the new head)
	# -- END SOLUTION --
	jr ra, 0
