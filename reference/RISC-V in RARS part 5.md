Procedures and Registers

Which register should you use?

## Procedure

"Procedures are a basic unit of structured, modular **programming**", functions, subroutines, code blocks, etc. 
Procedures can have arguments and return value(s). In RISCV these arguments and return values are usually stored in registers. 

The procedure should be able to use arguments, save values, and return to the memory location that called it. We can load values from registers, store values to registers, and jump to memory locations stored in registers. Its all registers and instructions baby!

### Procedure arguments (REGISTER BREAKDOWN):
NOTE: only the x0 register is actually enforced you can put whatever you want in any of the other registers, but the convention is as follows (We follow conventions so AI can debug our code more effectively)
- **Arguments** registers a0 to a7 (x10 - x17): 
	- If you have more than 8 arguments: additional arguments must be pushed on the stack (https://stackoverflow.com/questions/79923/what-and-where-are-the-stack-and-heap)
		- "memory accesses (including stack accesses) can be costly instructions in a pipelined processor like the RISC-V"
	- If you have less than 8 arguments: available registers can be used as temporaries
		- These can and will get overwritten if not saved properly
		- Caller-saved registers (parent procedure)
- **Return Values** registers a0, a1 (x10, x11):
	- Convention is to return a value to parent procedure (caller) through register a0
	- RISC-V also set aside a1 to be used for procedures with multiple return values
- **Return Address Register** register ra (x1):
	- "Every procedure must save its return address"
	- "The address of an instruction in the caller code where the procedure must jump to (return) upon completion"
	- ''RISC-V (and all RISC processors) save the return address of a procedure automatically in register **ra (x1),** during the execution of a **jal** (jump and link) instruction"
	- OVERWRITING RETURN ADDRESS ISSUE:
		- If you have nested procedures ({A}main -> {B}procedure(input) -> {C}procedure(math))
		- calling jal on procedure {C} will overwrite the return address to procedure {A}
		- Procedure {B} has to save the return address to procedure {A} on the stack :( 
- **Stack Pointer** -sp register (x2): 
	- Points to last valid byte of the call stack
	- RISC-V: stack grows from high to low values. Every 'push' to the stack lowers the stack pointer by 4 bytes (32-bit processors). 
	- You can save to the stack by lowering the stack pointer (growing the stack) by the number of bytes you need
		- 4 Integers = 16 bytes -> addi sp, sp, -16 (now you have 16 bytes to do things with)
		- then you can save/load register values in those stack postions
			- sw ra, 0(sp) {save the return address to the 0(sp) position on the stack} **S - type**
			- lw ra, 0(sp) {load the return address into register ra from the stack} **I-type**
- **Frame Pointer** - fp (x8): 
	- Also the s0 register. Points the the bottom of the stack (First valid byte)
	- Just a saved register that can be used for optimization and dynamic memory allocation
- **Global Data Area Pointer - Global Pointer - gp register** (x3):
	- "points to the middle of a memory region of 4 Kilobytes that a program can access with a single load instruction or store instruction"
	- 0x800 - 0x7ff (-2048 - 2047) I-type and S-type have 12 bits for memory addresses
- **Zero** register (x0): hardwired to the register. Is always zero, you can write to it but it will remain zero. 

**I -Type** (12 bits for address)

| imm[11:0] | rs1 | funct3 | rd | opcode |
|---|---|---|---|---|
| 12 | 5 | 3 | 5 | 7 |
| I-immediate[11:0] | src | LW/ADDI/LBU[U] | dest | OP-IMM |
| I-immediate[11:0] | src | ecall/XORI/SLLI | dest | OP-IMM |


**S-Type** (12 bits split)(12 bits for address)

|imm[12]|imm[10:5]|rs2|rs1|funct3|imm[4:1]|imm[11]|opcode|
|---|---|---|---|---|---|---|---|
|1|6|5|5|3|4|1|7|
|offset[12,10:5]||src2|src1|SW/SB/SD|offset[11,4:1]||BRANCH|


## Callee vs Caller

A procedure is either a caller, callee, or both. Most procedures are both.

### Saved vs Temporary Registers

RISC-V convention is to set aside some registers as saved and other registers as temporary. NOTE: this is just a convention, aside from the x0 register you can do whatever you want, but its always easier to follow conventions.

#### Temporary Registers
- Generally use temporaries when you do not want the values to last outside of the procedure using them. 
- {t0 - t6, a0 -a7} temporary registers should be saved to the stack by the caller function before getting used by the callee. After the callee procedure runs the temporary registers that were saved should then be restored (loaded) from the stack.

#### Saved Registers
- Generally used and preserved after a procedure call. The caller can set the values of these registers and expect that these values will persist after subsequent procedure calls. 
- If a callee wants to use these registers they should save the values to the stack before they use these registers, and load the values from the stack into the registers before they finish. 
- {s0-s11} Saved registers should be saved to the stack by the callee before use and loaded back to their original state after use. 
