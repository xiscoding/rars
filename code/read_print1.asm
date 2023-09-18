.data
prompt: .asciz "Enter a number: "
response: .asciz "\nYou input: "
.text
main: la a0, prompt # load prompt
  li a7, 4 # 4 = printString  
  ecall

  li a7, 5 # 5 = readInt
  ecall # int stored in a0

  add t1, zero, a0 #backup value

  la a0, response # print response
  li a7, 4 # 4 = printString
  ecall

  li a0, 4 # allocate bytes on the heap
  li a7, 9 # (allocate heap memory)
  ecall # pointer stored in a0

  sw t1, (a0) # store value in heap

  li t1, 0 # clear register so the value is only stored on the heap

  lb a0, (a0) # read back from memory

 li a7, 1 # 1 = printInt
 ecall

 li a7, 10 # 10 = exit
 ecall
