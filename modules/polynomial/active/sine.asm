; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		sine.asm
;		Purpose :	Sine evaluation
;		Date :		13th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;						Sine calculation of FPA (in Radians)
;
; *******************************************************************************************

PolySine:
		lda 	aFlags						; save original sign
		sta 	polySign 					
		stz 	aFlags 						; take absolute value
		;
		;		Divide FPA by 2.Pi
		;
		jsr 	PolyCopyFloatB 				; multiply by 1 / (2.Pi) (e.g. divide by 2.Pi)
		!word	FloatConst_1Div2Pi
		jsr 	FloatMultiply
		jsr 	FloatFractional 			; take the fractional part.
		;
		;		Rounded into 0-360 (in scaled radians), so x 4 to get the quadrant
		;
		inc 	aExponent 					; x 2
		inc 	aExponent 					; x 4
		+Push32A 							; save this value
		jsr 	FloatInteger

		;
		;		Work out the fractional part and adjust for quadrants 1 & 3
		;
		+Pop32B 							; get the 4 x value back to B
		+Copy32BA							; copy to A. 
		jsr 	FloatFractional 			; fractional part, not quadrant
		;
		; 		Save FPA for end multiply 
		;
		+Push32A 							; save FPA
		;
		;		Calculate FPA^2
		;
		+Push32A 							; square FPA - copy to FPB (slowly) and multiply
		+Pop32B
		jsr 	FloatMultiply 				

		;
		;		Apply the polynomial and multiply by the saved value.
		;
		ldx 	#PolynomialSineData-PolynomialData
		jsr 	PolyEvaluate
		+Pop32B 							; now multiply by the original value
		jsr 	FloatMultiply 				

		lda 	polySign 					; get original sign
		bpl 	_PSExit 
		lda 	aFlags 						; if was -ve negate the result.
		eor 	#$80
		sta 	aFlags		
_PSExit:		
		rts		

