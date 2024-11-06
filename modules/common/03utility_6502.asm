; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		03utility_6502.asm
;		Purpose :	Utility routines and/or macros, 6502 version.
;		Date :		5th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

!if CPU=6502 {

!macro copyreg .target,.source {
	lda 	.source+0
	sta 	.target+0
	lda 	.source+1
	sta 	.target+1
	lda 	.source+2
	sta 	.target+2
	lda 	.source+3
	sta 	.target+3
	lda 	.source+4
	sta 	.target+4
	lda 	.source+5
	sta 	.target+5
}

; -------------------------------------------------------------------------------------------
;
;							Copy B to A as 32 bit integer
;
; -------------------------------------------------------------------------------------------
Copy32BA6502:
	+copyreg aFlags,bFlags
	rts

; -------------------------------------------------------------------------------------------
;
;						Add B to A as 32 bit integer, sets N and C 
;
; -------------------------------------------------------------------------------------------
Add32AB6502:
	clc 
	lda 	aMantissa+0
	adc 	bMantissa+0
	sta 	aMantissa+0
	lda 	aMantissa+1
	adc 	bMantissa+1
	sta 	aMantissa+1
	lda 	aMantissa+2
	adc 	bMantissa+2
	sta 	aMantissa+2
	lda 	aMantissa+3
	adc 	bMantissa+3
	sta 	aMantissa+3
	rts
; -------------------------------------------------------------------------------------------
;
;						Subtract B from A as 32 bit integer, sets N and C 
;
; -------------------------------------------------------------------------------------------
Sub32AB6502:
	sec 
	lda 	aMantissa+0
	sbc 	bMantissa+0
	sta 	aMantissa+0
	lda 	aMantissa+1
	sbc 	bMantissa+1
	sta 	aMantissa+1
	lda 	aMantissa+2
	sbc 	bMantissa+2
	sta 	aMantissa+2
	lda 	aMantissa+3
	sbc 	bMantissa+3
	sta 	aMantissa+3
	rts	
; -------------------------------------------------------------------------------------------
;
;									Shift A right 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
Shr32A6502:
	lsr 	aMantissa+3
	ror 	aMantissa+2
	ror 	aMantissa+1
	ror 	aMantissa+0
	rts
; -------------------------------------------------------------------------------------------
;
;									Shift B right 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
Shr32B6502:
	lsr 	bMantissa+3
	ror 	bMantissa+2
	ror 	bMantissa+1
	ror 	bMantissa+0
	rts
; -------------------------------------------------------------------------------------------
;
;											Negate A
;
; -------------------------------------------------------------------------------------------
Neg32A6502:
	sec
	lda 	#0
	sbc 	aMantissa+0
	sta 	aMantissa+0
	lda 	#0
	sbc 	aMantissa+1
	sta 	aMantissa+1
	lda 	#0
	sbc 	aMantissa+2
	sta 	aMantissa+2
	lda 	#0
	sbc 	aMantissa+3
	sta 	aMantissa+3
	rts
}
; -------------------------------------------------------------------------------------------
;
;								Shift A left 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
Shl32A6502:
	asl 	aMantissa+0
	rol 	aMantissa+1
	rol 	aMantissa+2
	rol 	aMantissa+3
	rts
; -------------------------------------------------------------------------------------------
;
;								Shift B left 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
Shl32B6502:
	asl 	bMantissa+0
	rol 	bMantissa+1
	rol 	bMantissa+2
	rol 	bMantissa+3
	rts
; -------------------------------------------------------------------------------------------
;
;									Check if A is zero
;
; -------------------------------------------------------------------------------------------
Test32A6502:
	lda 	aMantissa+0
	ora 	aMantissa+1
	ora 	aMantissa+2
	ora 	aMantissa+3
	rts
; -------------------------------------------------------------------------------------------
;
;									Check if B is zero
;
; -------------------------------------------------------------------------------------------
Test32B6502:
	lda 	bMantissa+0
	ora 	bMantissa+1
	ora 	bMantissa+2
	ora 	bMantissa+3
	rts

