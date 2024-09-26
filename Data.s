.align 16
.ascii "DATA SECTION"
.align 16
.ascii "trackOffsetTable"
.align 16

trackOffsetTable:
; Mushroom Cup
;.word 0x04 :: .word 0x05 :: .word 0x09 :: .word 0x07
.word 0x38 :: .word 0x05 :: .word 0x09 :: .word 0x07
; Flower Cup
.word 0x0C :: .word 0x11 :: .word 0x12 :: .word 0x0B
; Lightning Cup
.word 0x08 :: .word 0x14 :: .word 0x0D :: .word 0x06
; Star Cup
.word 0x10 :: .word 0x0E :: .word 0x0A :: .word 0x0F
; Special Cup
.word 0x17 :: .word 0x15 :: .word 0x16 :: .word 0x13

.align 16
.ascii "trackHeaderTable"
.align 16

trackHeaderTable:
.incbin "TrackHeaderTable.bin"
; Next Offset = 0x38
.word org(customTrackHeader)
.word org(customTrackHeader)
.word org(customTrackHeader)
.word org(customTrackHeader)
.word org(customTrackHeader)
.word org(customTrackHeader)
.word org(customTrackHeader)

; Move MC1 so the track table has room to expand.
marioCircuit1:
.incbin "mksc.gba", 0x2580D4, 0x30A8

; Insert Extra Track Data Below
customTrackHeader:
	.word 0x31
	.word 0x0
	.word 0x4
	.word 0x1
	.word 0x2
	.word 0x0
	.word 0x1b
	.word 0x080EB720
	.word org(customTrackCover)
	.word org(customTrackCoverPal)
	.word 0x0
	.word org(customTrackNameGfx)
	.word 0x3
customTrackCover:
	.incbin "exampleTrack/cover.bin"
customTrackCoverPal:
	.incbin "exampleTrack/coverPal.bin"
customTrackNameGfx:
	.incbin "exampleTrack/nameGfx.bin"

customTrack:
	.incbin "exampleTrack/track.bin"
