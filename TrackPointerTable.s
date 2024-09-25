; ---   Instructions for adding a track ---
; Take the binary file that has all of your track data and
; put it in this folder (eg CustomTrack.bin)
; At the end of Data.s, add these two lines.
/* 
CustomTrackName:
.incbin "CustomTrack.bin"
*/
; You can the names with your own
; Then to include the track, add the following anywhere below ".org 0x082580d4":
/*
.word org(CustomTrackName)
*/
; TODO custom track header format so you can include custom track

.org 0x082580d4







; Do not edit below this unless you know what you are doing
.org 0x08258000
	.word org(marioCircuit1)