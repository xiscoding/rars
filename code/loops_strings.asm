 # compute s = 1+2+3+...+(n-1),  for n>=2
                # register x26: n
                # register x27: s
                # register x28: i

        .data           # init. data memory with the strings needed:
str_n:  .asciz "n = "
str_s:  .asciz "       s = "
str_nl: .asciz "\n"

        .text           # program memory:

main:                       # (1) PRINT A PROMPT:
        addi    a7, zero, 4      # environment call code for print_string
        la      a0, str_n      # pseudo-instruction: address of string
        ecall                   # print the string from str_n
                            # (2) READ n (MUST be n>=2 --not checked!):
        addi    a7, zero, 5      # environment call code for read_int
        ecall                   # read a line containing an integer
        add     s10, a0, zero    # copy returned int from x10 to n
                            # (3) INITIALIZE s and i:
        add     s11, zero, zero     # s=0;
        addi    t3, zero, 1      # i=1;
loop:                       # (4) LOOP starts here
        add     s11, s11, t3   # s=s+i;
        addi    t3, t3, 1     # i=i+1;
        bne     t3, s10, loop  # repeat while (i!=n)
                            #     LOOP ENDS HERE
                            # (5) PRINT THE RESULT:
        addi    a7, zero, 4      # environment call code for print_string
        la      a0, str_s      # pseudo-instruction: address of string
        ecall                   # print the string from str_s
        addi    a7, zero, 1      # environment call code for print_int
        add     a0, s11, x0    # copy argument s to x10
        ecall                   # print the integer in x10 (s)
        addi    a7, zero, 4      # environment call code for print_string
        la      a0, str_nl     # pseudo-instruction: address of string
        ecall                   # print a new-line
                            # (6) START ALL OVER AGAIN (infinite loop)
        j       main            # unconditionally jump back to main
