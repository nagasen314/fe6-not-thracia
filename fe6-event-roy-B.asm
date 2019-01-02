	@ FE6 Character structs:
	@ - begin at 202AB78
	@ - 0x48 bytes long (base adddress iteration size)
	@
	@ Offsets from character struct address:
	@ - 0x00 word: pointer to character data
	@ - 0x32 byte: support partner #1
	@
	@ Example:
	@ Roy's character data starts at 6076D0
	@ The ID is located at 6076D4, with an offset of +0x4
	@ Roy's character ID is #0x01


	.align 2
	.thumb
	
	@ Set Constants
	zero: .word 0x00000000
	ldr r3,zero @ Error: invalid offset, value too big
	bsupp: .word 0x000000B1
	ldr r2,bsupp @ Error: invalid offset, target not word aligned + value too big
	
	@ CSP = CharStructPointer, initialize at beginning of char struct table.
	CSP: .word 0x0202AB78
	@ Load pointer to character data (based on CSP) into r0. Size: word
	ldr r0,CSP @ Error: invalid offset, value too big

LoopStart:
	@ Check to see if pointer to character data is 0x0. If so, we're at the end. Exit.
	cmp r0,r3
	beq Exit
	
	@ Add #0x4 to CSP to find address of character ID, load into r1.
	add r1,r0,#0x4
	@ Load character ID at offset of #0x4 from r1 into r2. Size: byte
	ldrb r2,[r1,#0x4]
	@ Compare character ID (byte) against known constant (Roy'd ID). If equal, move onto next character struct.
	cmp r2,#0x01
	beq LoopEnd
	
	@ Set support partner #1 value to 0xB1 (stored in r2)
	strb r2,[r0,#0x32] @ Error: invalid offset, value too big
	
LoopEnd:
	@  Increment character struct pointer by size of each struct.
	add r0,#0x48
	b LoopStart

Exit:
	bx lr
