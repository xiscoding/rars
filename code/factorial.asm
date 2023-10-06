.data
	# Factorial Prompts
	enter_number_prompt: .asciz "Enter the first positive integer: "
	final_value_prompt: .asciz "The factorial of the number you enter is: "
.text
la a0, enter_number_prompt
addi a7, zero, 5
ecall
la ra, EXIT

fact:  
	addi t0, zero, 2          # immediate 2 needed for "if(n<2)" 
        bge    a0 , t0, elseF     # if n<2 false, ie if n≥2 goto ELSE 
        addi a0, zero, 1          # THEN: create return-value 1, place in reg. a0 
        jr ra                    # return --this is the end of the "then" clause 

elseF: 
	addi sp, sp, -8           # PUSH1: allocate 8 Bytes on the stack 
	sw ra, 4(sp)              # PUSH2: save ra into first allocated word 
        sw     a0 , 0(sp)         # PUSH3: save my argument (n) into second word 
        addi a0, a0 , -1          # create argument (n-1) into a0 for my child 

        jal ra, fact              # call my child procedure
        add t0, a0, zero          # copy return value from my child into t0 
                                  # (because I need to restore my own argument into a0) 

        lw ra, 4(sp)              # POP1: restore ra from stack 
        lw     a0 , 0(sp)         # POP2: restore a0 from stack 
        addi sp, sp, 8            # POP3: dealloc the 8 B that I had allocated 
        mul a0, a0 , t0           # multiply my own arg a0==n times the return 
                                  # value from my child that I had copied into t0, and 
                                  # place the result into a0, as my own return value 
        jr ra      
       
EXIT:
	#print message 
	add t0, a0, zero #saved the result into t0 
	la a0, final_value_prompt #load the message into a0
	addi a7, zero, 4 #load ecall code 4 (print string) into a7
	ecall
	add a0, t0, zero 
	addi a7, zero, 1 #load ecall code 1 (print int) into a7 
	ecall
	
	# Quit
	li a7, 10
	ecall     