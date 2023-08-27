.text # Directive ".text": put the following into program memory
      # Register use: x6: variable "i"; x7: variable "k";
main: # label "main" = address for "j" to jump to
     addi x6, x0, 10
     addi x7, x0, 64
     add x28, x6, x7
     add x28, x28, x28
     add x28, x28, x7
     addi x7, x7, -1
     sub x7, x7, x6
     j main # jump back to main (infinite loop)