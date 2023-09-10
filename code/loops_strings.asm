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
        addi    x17, x0, 4      # environment call code for print_string
        la      x10, str_n      # pseudo-instruction: address of string
        ecall                   # print the string from str_n
                            # (2) READ n (MUST be n>=2 --not checked!):
        addi    x17, x0, 5      # environment call code for read_int
        ecall                   # read a line containing an integer
        add     x26, x10, x0    # copy returned int from x10 to n
                            # (3) INITIALIZE s and i:
        add     x27, x0, x0     # s=0;
        addi    x28, x0, 1      # i=1;
loop:                       # (4) LOOP starts here
        add     x27, x27, x28   # s=s+i;
        addi    x28, x28, 1     # i=i+1;
        bne     x28, x26, loop  # repeat while (i!=n)
                            #     LOOP ENDS HERE
                            # (5) PRINT THE RESULT:
        addi    x17, x0, 4      # environment call code for print_string
        la      x10, str_s      # pseudo-instruction: address of string
        ecall                   # print the string from str_s
        addi    x17, x0, 1      # environment call code for print_int
        add     x10, x27, x0    # copy argument s to x10
        ecall                   # print the integer in x10 (s)
        addi    x17, x0, 4      # environment call code for print_string
        la      x10, str_nl     # pseudo-instruction: address of string
        ecall                   # print a new-line
                            # (6) START ALL OVER AGAIN (infinite loop)
        j       main            # unconditionally jump back to main
