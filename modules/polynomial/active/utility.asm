; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		utility.asm
;		Purpose :	Utility polynomial functions
;		Date :		13th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;			Evaluate polynomial at offset X from PolynomialData using value in FPA
;										(Horner's method)
;
; *******************************************************************************************

PolyEvaluate:
		lda 	PolynomialData,x 			; get the number to do
		inx  								; point to first number.
		sta 	polyCoefficientCount 		; count of numbers

		ldy 	#5 							; copy poly x to workspace
_PECopy1:
		lda 	aFlags,y
		sta 	polyTempFloat,y
		dey 
		bpl 	_PECopy1

		+Clear32A 							; set FPA to zero.

_PEEvaluateLoop:		
		ldy 	#5 							; copy X back to FPB
_PECopy2:
		lda 	polyTempFloat,y
		sta 	bFlags,y
		dey 
		bpl 	_PECopy2
		jsr 	FloatMultiply 				; and multiply into FPA

		ldy 	#0 							; copy the next coefficient into FPB
_PECopy3:
		lda 	PolynomialData,x
		sta 	bFlags,y
		inx		
		iny
		cpy 	#6
		bne 	_PECopy3

		jsr 	FloatAdd 					; and add into FPB

		dec 	polyCoefficientCount 		; do for all coefficients
		bne 	_PEEvaluateLoop

		rts

; *******************************************************************************************
;
;						Load Floating Point value, address following to FPA/FPB.
;
; *******************************************************************************************

PolyCopyFloatA:
		pha 								; save registers
		phx
		phy
		jsr 	PolyCopyFloatCommon			; access following number common code
		ldy 	#5 							; copy data over.
_PCFACopy:
		lda 	(zTemp0),y
		sta 	aFlags,y
		dey
		bpl 	_PCFACopy		

		ply 								; fix up and exit
		plx
		pla
		rts

PolyCopyFloatB:
		pha 								; save registers
		phx
		phy
		jsr 	PolyCopyFloatCommon			; access following number common code
		ldy 	#5 							; copy data over.
_PCFBCopy:
		lda 	(zTemp0),y
		sta 	bFlags,y
		dey
		bpl 	_PCFBCopy		

		ply 								; fix up and exit
		plx
		pla
		rts

PolyCopyFloatCommon:
		tsx

		clc
		lda 	$0106,x 					; LSB of address
		sta 	zTemp0						; save for access
		adc 	#2
		sta 	$0106,x
		lda 	$0107,x 					; same with MSB
		sta 	zTemp0+1
		adc 	#0
		sta 	$0107,x

		ldy  	#1  						; do an indirect read at address + 1
		lda 	(zTemp0),y
		tax
		iny
		lda 	(zTemp0),y
		sta 	zTemp0+1
		stx 	zTemp0
		rts		

		