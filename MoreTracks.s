.gba
.open "mksc.gba", "MoreTracksPatch.gba", 0x08000000

.definelabel lz77uncompwram, 0x8061364
.definelabel loadDataStatus, 0x8030434
.definelabel setVramBuffer, 0x080303e4
.definelabel getTrackOffsetSMK, 0x08033bbc
.definelabel getTrackOffsetMKSC, 0x08033bac
.definelabel getTrackOffsetBattle, 0x08033bdc

.include "MoreTracksPatches.s"

.org 0x08400000
replace800b8d0:
	cmp r0, #0x0
	beq @@setMKSCTextVram
	cmp r0, #0x1
	beq @@setSMKTextVram
@@setMKSCTextVram:
	bl loadDataStatus
	ldr r1, =0x02018000 ; textBufferMKSC
	ldr r2, =0x06010A00 ; vramAddrMKSC
	ldr r3, =0x80000100 ; sizeMKSC
	bl setVramBuffer
	b @@swapPage
@@setSMKTextVram:
	bl loadDataStatus
	ldr r1, =0x02017c00 ; textBufferSMK
	ldr r2, =0x06010A00 ; vramAddrSMK
	ldr r3, =0x80000100 ;sizeSMK
	bl setVramBuffer
	b @@swapPage
.pool
@@swapPage:
	ldr r1, =0x11e4
	add r1, r8
	ldr r0, [r1,#0x0]
	cmp r0, #0x2
	bne @@nextPage
	mov r0, #0x0
	str r0, [r1, #0x0]
	b @@b8d0return
@@nextPage:
	add r0, r0, #0x1
	str r0, [r1, #0x0]
@@b8d0return:
	ldr r0, =(0x0800B8D4+1) ; return address
	bx r0
.pool
; 2aa2 data
; Replace 2aa2 with a jump to this address
replace8002aa2:
	cmp r0, #0x0
	beq @@mksc
	cmp r0, #0x1
	beq @@smk
@@page3:
	mov r3, r10
	lsl r4, r3, #0x2
	add r0, r4, #0x0
	bl getTrackOffsetPg3
	b @@return2aa2
@@smk:
	mov r3, r10
	lsl r4, r3, #0x2
	add r0, r4, #0x0
	bl getTrackOffsetSMK
	b @@return2aa2
@@mksc:
	mov r1, r10
	lsl r4, r1, #0x2
	add r0, r4, #0x0
	bl getTrackOffsetMKSC
.align 2
@@return2aa2:
	ldr r1, =0x8002abd ; return address + thumb
	bx r1
.pool
getTrackOffsetPg3:
	ldr r1, =org(_trackOffsetTable)
	lsl r0, r0, #0x2
	add r0, r0, r1
	ldr r0, [r0,#0x0]
	bx lr
.pool
.align 4
_trackOffsetTable:
.byte 0x04, 0x00, 0x00, 0x00, 0x05, 0x00, 0x00, 0x00, 0x09, 0x00, 0x00, 0x00, 0x07, 0x00, 0x00, 0x00 
.byte 0x0C, 0x00, 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00, 0x0B, 0x00, 0x00, 0x00 
.byte 0x08, 0x00, 0x00, 0x00, 0x14, 0x00, 0x00, 0x00, 0x0D, 0x00, 0x00, 0x00, 0x06, 0x00, 0x00, 0x00 
.byte 0x10, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x0F, 0x00, 0x00, 0x00 
.byte 0x17, 0x00, 0x00, 0x00, 0x15, 0x00, 0x00, 0x00, 0x16, 0x00, 0x00, 0x00, 0x13, 0x00, 0x00, 0x00 
.byte 0x1C, 0x00, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x00

.thumb
LoadTrackText:
	push {r4, r5, r6, r7, lr}
	add r3, r0, #0x0
	add r2, r1, #0x0
	ldr r0, [r3, #0x10]
	mov r1, #0x02
	cmp r0, #0x01
	beq @@PageSwitch
	ldr r1, [r3, #0x14]
@@PageSwitch:
	ldr r4, =0x000011E4
	add r0, r3, r4
	ldr r0, [r0, #0x00]
	cmp r0, #0x2
	beq @@MkscTextHandler
	cmp r0, #0x00
	bne @@SMKTextHandler
@@MkscTextHandler:
	lsl r0, r2, #0x01
	add r0, r0, r2
	add r0, r0, r1
	lsl r0, r0, #0x02
	ldr r4, =0x000010A4
	add r1, r3, r4
	add r1, r1, r0
	ldr r0, [r1, #0x00]
	cmp r0, #0x00
	beq @@_0800879C
	lsl r6, r2, #0x02
	lsl r0, r2, #0x03
	add r0, r0, r6
	lsl r5, r0, #0x08
	ldr r6, =0x02025400
	mov r4, #0x03
@@_08008776:
	add r1, r5, r6
	ldr r0, =0x080A28C8
	bl LZ77UnCompWram
	mov r0, #0xC0
	lsl r0, r0, #0x02
	add r5, r5, r0
	sub r4, r4, #0x01
	cmp r4, #0x00
	bge @@_08008776
	b @@return
.pool
@@_0800879C:
	mov r4, #0x00
	lsl r6, r2, #0x02
	ldr r7, =0x080E7FEC
	lsl r0, r2, #0x03
	add r0, r0, r6
	lsl r5, r0, #0x08
@@_080087A8:
	add r0, r6, r4
	bl getTrackOffsetMKSC
	lsl r0, r0, #0x02
	add r0, r0, r7
	ldr r0, [r0, #0x00]
	ldr r0, [r0, #0x30]
	ldr r1, =0x02025400
	add r1, r5, r1
	bl LZ77UnCompWram
	mov r0, #0xC0
	lsl r0, r0, #0x02
	add r5, r5, r0
	add r4, #0x01
	cmp r4, #0x03
	ble @@_080087A8
	b @@return
.pool
@@SMKTextHandler:
	lsl r0, r2, #0x01
	add r0, r0, r2
	add r0, r0, r1
	lsl r0, r0, #0x02
	mov r4, #0x87
	lsl r4, r4, #0x05
	add r1, r3, r4
	add r1, r1, r0
	ldr r0, [r1, #0x00]
	cmp r0, #0x00
	beq @@_08008814
	lsl r6, r2, #0x02
	lsl r0, r2, #0x03
	add r0, r0, r6
	lsl r5, r0, #0x08
	ldr r6, =0x02025400
	mov r4, #0x03
@@_080087F6:
	add r1, r5, r6
	ldr r0, =0x080A4A68
	bl LZ77UnCompWram
	mov r0, #0xC0
	lsl r0, r0, #0x02
	add r5, r5, r0
	sub r4, r4, #0x01
	cmp r4, #0x00
	bge @@_080087F6
	b @@return
.pool
@@_08008814:
	mov r4, #0x00
	lsl r6, r2, #0x02
	ldr r7, =0x080E7FEC
	lsl r0, r2, #0x03
	add r0, r0, r6
	lsl r5, r0, #0x08
@@_08008820:
	add r0, r6, r4
	bl getTrackOffsetSMK
	lsl r0, r0, #0x02
	add r0, r0, r7
	ldr r0, [r0, #0x00]
	ldr r0, [r0, #0x30]
	ldr r1, =0x02025400
	add r1, r5, r1
	bl LZ77UnCompWram
	mov r0, #0xC0
	lsl r0, r0, #0x02
	add r5, r5, r0
	add r4, #0x01
	cmp r4, #0x03
	ble @@_08008820
@@return:
	pop {r4, r5, r6, r7}
	pop {r0}
	bx r0
.pool

;
; track cover if statement replacement
;

.thumb
replace8008956:
	ldr r1, =0x000011E4
	add r0, r6, r1
	ldr r0, [r0, #0x00]
	ldr r1, [r6, #0x10]
	cmp r0, #0x01 
	bne @@CoverArtHandler ; Break if page != smk tracks
	cmp r1, #0x03
	bne @@MinimapCover ; or battle mode enabled
@@CoverArtHandler:
	cmp r1, #0x03
	beq @@_08008984
	cmp r0, #0x0
	beq @@MKSCCoverHandler
@@Pg3Handler:
	ldr r4, =0x080E7FEC
	add r0, r2, #0x0
	bl getTrackOffsetPg3
	b @@_0800898E
@@MKSCCoverHandler:
	ldr r4, =0x080E7FEC
	add r0, r2, #0x0
	bl getTrackOffsetMKSC
	b @@_0800898E
.pool
@@_08008984:
	ldr r4, =0x080E7FEC
	and r2, r1
	add r0, r2, #0x0
	bl getTrackOffsetBattle
@@_0800898E:
	lsl r0, r0, #0x02
	add r0, r0, r4
	ldr r2, [r0, #0x00]
	ldr r0, [r2, #0x24]
	ldr r1, =0x02004400
	bl LZ77UnCompWram
	b @@return
.pool
@@MinimapCover:
	ldr r4, =0x080E7FEC
	add r0, r2, #0x0
	bl getTrackOffsetSMK
	lsl r0, r0, #0x02
	add r0, r0, r4
	ldr r2, [r0, #0x00]
	ldr r1, [r2, #0x00]
	lsl r1, r1, #0x02
	ldr r0, =0x8258000
	add r1, r1, r0
	ldr r1, [r1, #0x00]
	add r0, r1, r0
	ldr r2, =0x082580C4
	add r1, r1, r2
	ldr r1, [r1, #0x00]
	add r0, r0, r1
	ldr r1, =0x02004400
	bl LZ77UnCompWram
@@return:
	ldr r1, =0x08008b3f ; return addr + thumb
	bx r1
.pool
.Close