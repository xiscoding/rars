.data
A_IN:
    # Fill out your code here
    .space 40
    
A_OUT:
    # Fill out your code here
    .space 40
PROMPT:
    .asciz "Enter an integer: "

.text
main:
    # Fill out your code here
    la t0, A_IN
    la t1, A_OUT
    addi     t2, x0, 10     # count = 10;
    add     s11, x0, x0     # i=0;

LOOP1:
    # Fill out your code here
    addi    s11, s11, 1	    #i += 1	
    
    addi    a7, zero, 4      # environment call code for print_string
    la      a0, PROMPT      # pseudo-instruction: address of string
    ecall  
    # (2) READ n (MUST be n>=2 --not checked!):
    addi    a7, zero, 5      # environment call code for read_int
    ecall                   # read a line containing an integer
    add     t3, a0, x0    # copy returned int from x10 to n
    
    sw t3, 0(t0) # save t3 value into arr[0]
    addi t0, t0, 4
    blt s11, t2, LOOP1 #loop if x27 < 10  
    addi     t2, zero, 10     # count = 10;
    add     s11, zero, zero     # i=0;     
    addi t0, t0, -4 # decrement t0 by 4                   
LOOP2:
    # Fill out your code here
    addi    s11, s11, 1	    #i += 1	
    lw t3, 0(t0)
    
    sw t3, 0(t1) # save t3 value into arr[0]
    addi t0, t0, -4 # decrement t0 by 4
    addi t1, t1, 4 # increment t1 by 4
    blt s11, t2, LOOP2 #loop if x27 < 10  
