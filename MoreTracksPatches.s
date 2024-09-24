.org 0x0800862e
	cmp r0, #0x1
	beq 0x08008648
.org 0x08008666
	cmp r0, #0x1
	beq 0x08008694
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

.org 0x080088fa
	cmp r0, #0x1
	bne 0x08008904

.org 0x08008872
	cmp r0, #0x1
	bne 0x0800887c

; Track cover art override. Don't override pools so no fill.
.org 0x08008956
.area 0xA
	ldr r1, =(replace8008956+1)
	bx r1
.pool
.endarea

; Controls Track image layout
.org 0x08008e2a
	cmp r0, #0x1
	beq 0x08008ee0

.org 0x080089f8
	cmp r0, #0x1
	bne 0x08008a02

.org 0x08008afa
	cmp r0, #0x1
	bne 0x08008b04

.org 0x080092ac
	cmp r0, #0x1
	bne 0x080092b8

.org 0x80095aa ; Might want finer control over this later, but for now just override if statement
	cmp r0, #0x1
	beq 0x080095c4
.org 0x0800a9f6
	cmp r0, #0x1
	beq 0x0800aa58
.org 0x0800abf0
	cmp r0, #0x1
	bne 0x0800ac30
; controls 2bpp vs 8bpp
.org 0x0800ae66
	cmp r0, #0x1
	bne 0x0800ae70

.org 0x0800b020
	cmp r0, #0x1
	beq 0x0800b056

.org 0x0800b048
	cmp r0, #0x1
	beq 0x0800b056

.org 0x0800b092
	cmp r0, #0x1
	beq 0x0800b0a2

.org 0x0800b0f8
	cmp r0, #0x1
	beq 0x0800b106

.org 0x0800b814
	cmp r0, #0x1
	beq 0x0800b82c

.org 0x0800bae2
	cmp r0, #0x1
	beq 0x0800baf8

.org 0x0800bb02
	cmp r0, #0x1
	beq 0x0800bb10

.org 0x0800bb36
	cmp r0, #0x1
	beq 0x0800bb48

.org 0x0800bb66
	cmp r0, #0x1
	beq 0x0800bb74

.org 0x0800c51e ; Almost certainly want more control here, but just overriding for now.
	cmp r0, #0x1
	beq 0x0800c554

.org 0x0800c52e ; Override locked tracks table
.area 0x26
	ldr r1, =(replace8000c52e+1)
	bx r1
.pool
.endarea
