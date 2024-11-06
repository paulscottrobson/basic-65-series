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

