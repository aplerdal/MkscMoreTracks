.org 0x0800B8D0
.area 0x56, 0x00
	ldr r1, =(replace800b8d0+1)
	bx r1
.pool
.endarea

.org 0x08002aa2
.area 0x1a, 0x00
	ldr r1, =(replace8002aa2+1)
	bx r1
.pool
.endarea

;Override Load Track Text function
.org 0x080094fa
	bl LoadTrackText
.org 0x0800ad22
	bl LoadTrackText

; Override if statement result
.thumb
.org 0x080088fa
	cmp r0, #0x1
	bne 0x8008904

; Track cover art override. Don't override pools so no fill.
.org 0x08008956
.area 0xA
	ldr r1, =(replace8008956+1)
	bx r1
.pool
.endarea