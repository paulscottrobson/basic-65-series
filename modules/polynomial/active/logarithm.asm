; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		logarithm.asm
;		Purpose :	Natural logarithm evaluation
;		Date :		14th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;						Logarithm calculation of FPA. Return CS on error
;
; *******************************************************************************************

PolyLogarithmE:
		pha
		phx
		phy
		lda 	aFlags 						; if negative, it's bad
		sec 								; so return with CS.
		bmi 	_PLEExit

		jsr 	FloatNormaliseA 			; normalise, might be integer
		;
		;		Extract the exponent, as a power of 2.
		;
		lda 	aExponent 					; work out the shift
		sbc 	#$E2  						; $E2 normalised is the required exponent offset
		pha  								; save on stack.

		lda 	#$E2 						; force into range 1-2.
		sta 	aExponent
		;
		;		subtract 1 from FPA
		;
		lda 	#1
		+Set32B
		jsr 	FloatSubtract
		;
		; 		Save FPA for end multiply 
		;
		+Push32A 							; save FPA
		;
		;		Apply the polynomial and multiply by the saved value.
		;
		ldx 	#PolynomialLogData-PolynomialData
		jsr 	PolyEvaluate
		+Pop32B 							; now multiply by the original value
		jsr 	FloatMultiply 				
		+Push32A 							; push the result on the stack
		;
		;		Get the exponent offset, multiply by Log(2)
		;
		pla 								; Set A to the exponent offset.
		+Set32A
		jsr 	PolyCopyFloatB 				; multiply by Log(2)
		!word	FloatConst_Log2
		jsr 	FloatMultiply
		;
		;		Restore previous result and add.
		;
		+Pop32B
		jsr 	FloatAdd
		clc
_PLEExit:
		ply
		plx
		pla
		rts

