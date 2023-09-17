Memory, Endianness, Alignment

"Memory is byte-addressable"

## Data Storage/ Location
- ### Addresses:
	- "data is stored in a contiguous array"
		- each piece of data is stored as a continuous block in memory
		- Each block of memory (a byte in this case) is numbered
	- The address of a piece of data in memory is its lowest numbered bit
- ### Memory Lines/ Channels
	- Memory has width
	- For each instruction one block of memory can be loaded.
	- Memory Channel: the amount of memory that can be loaded per instruction
	- Processor returns all the bytes in a given memory width
		- If less bytes needed than memory width
			- Processor selects and keeps the bytes it need
		- If more bytes needed than memory width
			- two calls to memory must be made 
- ### Alignment
	- To minimize instruction calls its best to keep memory aligned.
	- Alignment: storing data in a way to minimize load instructions needed.
	- In RISC-V alignment is optional 

## Endianness
- Data is generally stored in two ways. Big Endian and Little Endian.
- ### Big Endian 
	- The first byte of the piece of data is stored in the first byte of the memory block
- ### Little Endian
	- The first byte of the piece of data is stored in the last byte of the memory block

**Example: store int x = 0x000001a4**

|memory location|8-9|9-a|a-b|b-c|
|---|---|---|---|---|
|Big Endian|00|00|01|a4|
|Little Endian|a4|01|00|00|

## Assembler Directives

| Directive | Instruction | Description |
| ---------- | ------------ | -----------|
| .align | int |  Align to the given boundary, with the size given as log2 the number of bytes to align to. (Start next block 2^'int' spaces away) |
| .space | int | reserve space for 'int' bytes | 

