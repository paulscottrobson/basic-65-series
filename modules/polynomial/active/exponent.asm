; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		exponent.asm
;		Purpose :	Exponent evaluation
;		Date :		14th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;									Calculation of e^FPA 
;
; *******************************************************************************************

PolyExponent:
		pha
		phx
		phy
		;
		;		Save sign, take absolute value
		;
		lda 	aFlags
		sta 	polySign
		stz 	aFlags
		;
		;		Multiply FPA by log2 e
		;
		jsr 	PolyCopyFloatB 				; multiply by log2 e
		!word 	FloatConst_Log2_E
		jsr 	FloatMultiply
		;
		;		Extract the integer part.
		;
		+Push32A 							; push FPA as we want it restored after this bit.
		jsr 	FloatInteger 				; take and save the integer part
		lda 	aMantissa+0 			
		sta 	polyExponent
		+Pop32B
		+Copy32BA
		jsr 	FloatFractional 			; extract the fractional part
		;
		;		Handle -ve values in original FPA. Negate the exponent and the value for x
		;
		bit 	polySign
		bpl 	_PENotNegative

		sec 								; negate the exponent
		lda 	#0
		sbc 	polyExponent
		sta 	polyExponent

		lda 	#$80 						; make FPA negative
		sta 	aFlags

_PENotNegative:		
		;
		;		Take fractional part of FPA and calculate the Polynomial (which is 2^x, not the standard exp() taylor series)
		;
		ldx 	#PolynomialExpData-PolynomialData
		jsr 	PolyEvaluate
		;
		;		Add the exponent extracted earlier
		;
		clc
		lda 	polyExponent
		adc 	aExponent
		sta 	aExponent

		ply
		plx
		pla
		rts

