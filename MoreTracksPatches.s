.gba
.open "mksc.gba", "MoreTracksPatch.gba", 0x08000000

.definelabel replace800b8d0, 0x08000010
.org 0x0800B8D0
.area 0x56, 0x00
	ldr r1, =0x800b928
	bx r1
.pool
.endarea

.org 0x08002aa2
.area 0x56, 0x00
	ldr r1, =0x800b928
	bx r1
.pool
.endarea

.Close