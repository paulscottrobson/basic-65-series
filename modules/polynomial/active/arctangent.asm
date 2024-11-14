; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		arctangent.asm
;		Purpose :	ArcTangent evaluation
;		Date :		14th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;				  ArcTangent calculation of FPA (in Radians). Return CS on error
;
; *******************************************************************************************

PolyArcTangent:
		pha
		phx
		phy
		jsr 	FloatNormaliseA 			; normalise A so we can compare >= 1

		lda 	aFlags 						; save the current sign of FPA 
		sta 	polySign 					
		stz 	aFlags 						; take absolute value of A

		;
		;		if FPA >= 1.0, take reciprocal of FPA
		;
		stz 	polyFlag 					; clear the adjust flag.
		lda 	aExponent 					; is the exponent >= $E2 , this means >= 1
		bpl 	_PATAdjust 					; definitely > 1 :)
		cmp 	#$E2 						; $E2..$FF are also > 1
		bcc 	_PATNotAdjust
_PATAdjust:		
		+Push32A 							; copy FPA to FPB
		+Pop32B
		lda 	#1 							; FPA = 1, FPB = x
		+Set32A
		jsr 	FloatDivide 				; take reciprocal
		inc 	polyFlag 					; set the adjust flag
_PATNotAdjust:		
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
		ldx 	#PolynomialArctanData-PolynomialData
		jsr 	PolyEvaluate
		+Pop32B 							; now multiply by the original value
		jsr 	FloatMultiply 				
		;
		;		If adjusted subtract result from Pi/2
		;
		lda 	polyFlag
		beq 	_PATNoFixup

		lda 	aFlags 						; FPA = -FPA
		eor 	#$80
		sta 	aFlags
		jsr 	PolyCopyFloatB 				; FPB = Pi/2
		!word 	FloatConst_PiDiv2		
		jsr 	FloatAdd
_PATNoFixup:		
		;
		;		Restore sign
		;
		lda 	polySign 					; restore the original sign
		sta 	aFlags

		ply
		plx
		pla
		rts

