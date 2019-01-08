	.thumb
	
	@ Notes
	@ r0: CharStructPointer (CSP) 
	@ r1: Allegiance comparator		CharDataPointer (CDP)		CSP to Support Partner #1 offset
	@ r2: 							Character ID comparator		Points value for B-rank support
	
	@ Initialize CSP at beginning of char struct table.
	.equ CSP, 0x0202AB78
	@ Load pointer to character data (based on CSP) into r0. Size: word
	ldr r0,=CSP

LoopStart:
	@ Load allegiance byte into r1 from CSP+0x0B.
	ldrb r1,[r0,#0x0B]
	@ Check to see if allegiance byte is >= 0x40 (NPC). If so, we're at the end. Exit.
	cmp r1,#0x40
	bhs Exit
	
	@ Load CDP into r1 from address=CSP+0x0.
	ldr r1,[r0]
	@ If the CDP is #0x0 (empty slot), move on.
	cmp r1,#0x0
	beq LoopEnd
	
	@ Load character ID at offset of #0x4 from r1 into r2. Size: byte
	ldrb r2,[r1,#0x4]
	@ Compare character ID (byte) against known constant (Roy'd ID). If equal, move onto next character struct.
	cmp r2,#0x01
	beq LoopEnd
	
	@ Offset from CSP to Support Partner #1 value 
	mov r1,#0x30
	@ Points value for A-support
	mov r2,#0xF1
	@ Store support partner #1 location: CSP+offset
	strb r2,[r0,r1]
	
LoopEnd:
	@  Increment character struct pointer by size of each struct.
	add r0,#0x48
	b LoopStart

Exit:
	bx lr
