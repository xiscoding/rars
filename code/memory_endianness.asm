.data
  prompt: .asciz "Enter a 3 character string: "

.text
main: 
#print prompt
  la a0, prompt 
  li a7, 4
  #addi a7, x0, 4 #4: print string code
  ecall

  li a0, 4 # allocate 4 bytes
  #addi a0, x0, 4
  li a7, 9 #stores address in a0
  #addi a7, x0, 9
  ecall

  li a1, 4 # read 4 bytes into memory located at address stored in a0
  #addi a1, x0, 4
  li a7, 8 #8: read_characters code
  #addi a7, x0, 8
  # reads up to (length - 1) characters into a buffer whose address is in a1 
  # terminates the string with a null byte. 
  # Buffer size has to be at least length bytes.
  ecall

  #print binary code: 23
  #li a0, 23
  #li a1, 0xa
  #ecall
  
  li a7, 10 #10: exit code
  #addi a7, x0, 10
  ecall
