Reading, Printing, Conditional Statements

## Assembler Directives
Directive: n. official instruction
[RISC-V Assembler Reference](https://michaeljclark.github.io/asm.html)
https://www.cs.cornell.edu/courses/cs3410/2019sp/schedule/slides/11-linkload-notes-bw.pdf
https://downloads.ti.com/docs/esd/SPRUI03A/Content/SPRUI03A_HTML/assembler_directives.html#:~:text=Assembler%20directives%20supply%20data%20to,Control%20the%20appearance%20of%20listings

"The assembler implements a number of directives (INSTRUCTIONS) that control the assembly of instructions into an object file. These directives give the ability to include arbitrary data in the object file, control exporting of symbols, selection of sections, alignment of data, assembly options for compression, position dependent and position independent code."

| Directive | Instruction | Description |
| ---------- | ------------ | -----------|
| .data | N/A | Portion spot in memory for global/static variables needed in program (emit .data section create if none) |
| .asciz | "String" | portion spot in memory for a string object (strings are followed by zero byte) | 
| .text | N/A | Portion spot in memory for instructions in program |

## Instructions 
[jemu.oscc.cc](https://jemu.oscc.cc/BNE)
[riscv.org](https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf)

#### Structure of basic instruction:

| imm[11:0] | rs1 | funct3 | rd | opcode |
|---|---|---|---|---|
| 12 | 5 | 3 | 5 | 7 |
| I-immediate[11:0] | src | ADDI/SLTI[U] | dest | OP-IMM |
| I-immediate[11:0] | src | ANDI/ORI/XORI | dest | OP-IMM |

| imm[12] | imm[10:5] | rs2 | rs1 | funct3 | imm[4:1] | imm[11] | opcode |
|---|---|---|---|---|---|---|---|
| 1 | 6 | 5 | 5 | 3 | 4 | 1 | 7 |
| offset[12,10:5] || src2 | src1 | BEQ/BNE | offset[11,4:1] || BRANCH |
| offset[12,10:5] || src2 | src1 | BLT[U] | offset[11,4:1] || BRANCH |
| offset[12,10:5] || src2 | src1 | BGE[U] | offset[11,4:1] || BRANCH |

#### Symbol: 
- the variables in the .data section
- the variables themselves are stored in memory and the memory location address is stored in the registers

| Instruction      | Syntax | Example    |
| ---        |    ---  |          --- |
| addi      | add rd,rs1,rs2       | rd = rs1 + rs2   |
| la   | la rd, symbol        | la x10, str_n      |
| ecall | auipc rd, symbol[31:12] + 1 <br> addi rd, symbol [11:0]| la x10, str_n |
| bne | bne rs1, rs2, label | bne x28, x26, loop |

#### Registers:
x10 (a0): Function arguments/Return values
x17 (a7): Function arguments
x28 (t3): Temporaries
#### addi/add: 
- watch part 2
#### la:
[github quicky](https://github.com/riscv/riscv-isa-manual/issues/144)
[groups.google](https://groups.google.com/a/groups.riscv.org/g/sw-dev/c/sDQWmHyzHi8)
- psuedo-instruction: a call to perform other actual instructions
-  The base RISC-V ISA has fixed-length 32-bit instructions that must be naturally aligned on 32-bit boundaries
	- two commands are need to hold all the instruction information
- Load address to symbol into rd

#### ecall:
- Environment/System call:
	- "The ECALL instruction is used to make a request to the supporting execution environment, which is usually an operating system. The ABI for the system will define how parameters for the environment request are passed, but usually these will be in defined locations in the integer register file." [riscv-spec-v2](https://riscv.org/wp-content/uploads/2016/06/riscv-spec-v2.1.pdf)
	- "instruction does an atomic jump to a controlled location" [additional info]](https://www.cs.cornell.edu/courses/cs3410/2019sp/schedule/slides/14-ecf-pre.pdf)
	- instruction to tell cpu to perform the task specified by the code stored in the register
	- This program has 3 codes 
- ecall codes:
[cs.sfu.ca](https://www.cs.sfu.ca/~ashriram/Courses/CS295/tutorials/venus/venus_ecalls.html#:~:text=The%20ecall%20instruction%20is%20a,ecalls%20for%20you%20to%20use.)
	- [eecs.yorku.ca](https://www.eecs.yorku.ca/course_archive/2022-23/F/2021A/RVS/RVS-IOsyscalls008.pdf)
		- Print:
			- **print_integer (ecall rd, rs, 0)**
			- print_float (ecall rd, rs, 1)
			- print_hexadecimal (ecall rd, rs, 2)
			- print_characters (ecall rd, rs, 3)
			- **print_string (ecall rd, rs, 4)**
		- Input (Read):
			- **read_integer (ecall rd, rs, 5)**
			- read _float (ecall rd, rs, 6)
			- read _hexadecimal (ecall rd, rs, 7)
			- read _characters (ecall rd, rs, 8)
			- read _string (ecall rd, rs, 9)
#### bne:
- branch not equal: [BNE](https://jemu.oscc.cc/BNE) branch if `register**rs1**` is not equal to `register**rs2**`,
- 
	