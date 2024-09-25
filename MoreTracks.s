.gba
.open "mksc.gba", "MoreTracks.gba", 0x08000000

.definelabel originalTrackPointerTable, 0x8258000
.definelabel lz77uncompwram, 0x8061364
.definelabel loadDataStatus, 0x8030434
.definelabel setVramBuffer, 0x080303e4
.definelabel getTrackOffsetSMK, 0x08033bbc
.definelabel getTrackOffsetMKSC, 0x08033bac
.definelabel getTrackOffsetBattle, 0x08033bdc

.include "MoreTracksPatches.s"
.include "MoveTrackHeader.s"
.include "TrackPointerTable.s"

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

; Pretty sure this handles which track is loaded when starting the game.
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
	ldr r1, =org(trackOffsetTable)
	lsl r0, r0, #0x2
	add r0, r0, r1
	ldr r0, [r0,#0x0]
	bx lr
.pool
.align 4

.thumb
LoadTrackText:
	push {r4, r5, r6, r7, lr}
	add r3, r0, #0x0
	add r2, r1, #0x0
	ldr r0, [r3, #0x10]
	mov r1, #0x02
	cmp r0, #0x01
	beq @@SwitchOnPage
	ldr r1, [r3, #0x14]
@@SwitchOnPage:
	ldr r4, =0x000011E4
	add r0, r3, r4
	ldr r0, [r0, #0x00]
	cmp r0, #0x0
	beq @@MkscTextHandler
	cmp r0, #0x01
	beq @@SMKTextHandler
	; fall into pg3 handler
@@Pg3TextHandler:
	lsl r0, r2, #0x01
	add r0, r0, r2
	add r0, r0, r1
	lsl r0, r0, #0x02
	ldr r4, =0x000010A4
	add r1, r3, r4
	add r1, r1, r0
	ldr r0, [r1, #0x00]
	cmp r0, #0x00
	beq @@Pg3UnlockedTextHandler
	lsl r6, r2, #0x02
	lsl r0, r2, #0x03
	add r0, r0, r6
	lsl r5, r0, #0x08
	ldr r6, =0x02025400
	mov r4, #0x03
@@Pg3LockedTextHandler:
	add r1, r5, r6
	ldr r0, =0x080A28C8
	bl LZ77UnCompWram
	mov r0, #0xC0
	lsl r0, r0, #0x02
	add r5, r5, r0
	sub r4, r4, #0x01
	cmp r4, #0x00
	bge @@Pg3LockedTextHandler
	b @@return
@@Pg3UnlockedTextHandler:
	mov r4, #0x00
	lsl r6, r2, #0x02
	ldr r7, =org(trackHeaderTable)
	lsl r0, r2, #0x03
	add r0, r0, r6
	lsl r5, r0, #0x08
@@GetPg3TextLoop:
	add r0, r6, r4
	bl getTrackOffsetPg3
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
	ble @@GetPg3TextLoop
	b @@return
.pool
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
	beq @@MKSCUnlockedTextHandler
	lsl r6, r2, #0x02
	lsl r0, r2, #0x03
	add r0, r0, r6
	lsl r5, r0, #0x08
	ldr r6, =0x02025400
	mov r4, #0x03
@@MKSCLockedTextHandler:
	add r1, r5, r6
	ldr r0, =0x080A28C8
	bl LZ77UnCompWram
	mov r0, #0xC0
	lsl r0, r0, #0x02
	add r5, r5, r0
	sub r4, r4, #0x01
	cmp r4, #0x00
	bge @@MKSCLockedTextHandler
	b @@return
@@MKSCUnlockedTextHandler:
	mov r4, #0x00
	lsl r6, r2, #0x02
	ldr r7, =org(trackHeaderTable)
	lsl r0, r2, #0x03
	add r0, r0, r6
	lsl r5, r0, #0x08
@@GetMkscTextLoop:
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
	ble @@GetMkscTextLoop
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
	beq @@SMKUnlockedTextHandler
	lsl r6, r2, #0x02
	lsl r0, r2, #0x03
	add r0, r0, r6
	lsl r5, r0, #0x08
	ldr r6, =0x02025400
	mov r4, #0x03
@@SMKLockedTextHandler:
	add r1, r5, r6
	ldr r0, =0x080A4A68
	bl LZ77UnCompWram
	mov r0, #0xC0
	lsl r0, r0, #0x02
	add r5, r5, r0
	sub r4, r4, #0x01
	cmp r4, #0x00
	bge @@SMKLockedTextHandler
	b @@return
@@SMKUnlockedTextHandler:
	mov r4, #0x00
	lsl r6, r2, #0x02
	ldr r7, =org(trackHeaderTable)
	lsl r0, r2, #0x03
	add r0, r0, r6
	lsl r5, r0, #0x08
@@GetSMKTextLoop:
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
	ble @@GetSMKTextLoop
@@return:
	pop {r4, r5, r6, r7}
	pop {r0}
	bx r0
.pool

;
; track cover if statement replacement
;

replace8008956:
	ldr r1, =0x000011E4
	add r0, r6, r1
	ldr r0, [r0, #0x0]
	ldr r1, [r6, #0x10]
	cmp r0, #0x01
	bne @@CoverArtHandler
	cmp r1, #0x03
	bne @@MinimapCover
@@CoverArtHandler:
	cmp r1, #0x03
	beq @@BattleCoverHandler
	cmp r0, #0x0
	beq @@MKSCCoverHandler
.pool
@@Pg3Handler:
	ldr r4, =org(trackHeaderTable)
	add r0, r2, #0x0
	bl getTrackOffsetPg3
	b @@_0800898E
@@MKSCCoverHandler:
	ldr r4, =org(trackHeaderTable)
	add r0, r2, #0x0
	bl getTrackOffsetMKSC
	b @@_0800898E
.pool
@@BattleCoverHandler:
	ldr r4, =org(trackHeaderTable)
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
	ldr r4, =org(trackHeaderTable)
	add r0, r2, #0x0
	bl getTrackOffsetSMK
	lsl r0, r0, #0x02
	add r0, r0, r4
	ldr r2, [r0, #0x00]
	ldr r1, [r2, #0x00]
	lsl r1, r1, #0x02
	ldr r0, =0x08258000
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
	ldr r1, =0x080089D1
	bx r1
.pool

replace8000c52e:
	lsl r0, r1, #0x1
	add r0, r0, r1
	add r0, r0, r2
	lsl r0, r0, #0x2
	ldr r1, =0x10A4
	add r1, r8
	add r1, r1, r0
	ldr r0, [r1,#0x0]
	cmp r0, #0x1
	bne @@return
@@SetPixelizedCover:
	ldrh r0, [r5,#0x0]
	ldr r0, =0x2222
	strh r0, [r5, #0x0]
	ldrh r1, [r4, #0x0]
	mov r0, #0x40
	orr r1,r0
	ldrh r0, [r4, #0x0]
	orr r1, r6
	strh r1, [r4, #0x0]
@@return:
	ldr r1, = 0x800c555 ; return addr + thumb bit
	bx r1
.pool

replace80089f8:
	add r2, r3, r6
	ldr r2, [r2,#0x0]
	cmp r2, #0x0
	beq @@MkscHandler
@@Pg3Handler:
	bl getTrackOffsetPg3
	b @@return
@@MkscHandler:
	bl getTrackOffsetMKSC
@@return:
	lsl r0, r0, #0x2
	add r0, r0, r4
	ldr r2, [r0, #0x0]
	ldr r1, =0x08008a29
	bx r1
.pool
.include "Data.s"
.Close
