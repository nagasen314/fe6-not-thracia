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

	.thumb
	
	@ Notes
	@ r0: CharStructPointer (CSP)
	@ r1: CharDataPointer (CDP)
	@ No guarantee that units in between won't be empty. Rethink your termination condition.
	@ Count units (?)
	@ Find out where the last character struct is located (?)
	
	@ Set Constants
	.equ bsupp, 0x000000B1
	ldr r2,bsupp @ Error: invalid offset, target not word aligned + value too big
	
	@ Initialize CSP at beginning of char struct table.
	.equ CSP, 0x0202AB78
	@ Load pointer to character data (based on CSP) into r0. Size: word
	ldr r0,CSP @ Error: invalid offset, value too big

LoopStart:
	@ Load CDP into r1 from CSP+0x0.
	ldr r1,[r0]
	@ Check to see if CDP is 0x0. If so, we're at the end. Exit.
	cmp r1,#0
	beq Exit
	
	@ Load character ID at offset of #0x4 from r1 into r2. Size: byte
	ldrb r2,[r1,#0x4]
	@ Compare character ID (byte) against known constant (Roy'd ID). If equal, move onto next character struct.
	cmp r2,#0x01
	beq LoopEnd
	
	@ Set support partner #1 value (CSP+0x32) to 0xB1 (stored in r2)
	strb r2,[r0,#0x32] @ Error: invalid offset, value too big
	
LoopEnd:
	@  Increment character struct pointer by size of each struct.
	add r0,#0x48
	b LoopStart

Exit:
	bx lr
