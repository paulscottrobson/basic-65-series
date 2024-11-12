; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		floattostr.asm
;		Purpose :	Float to string conversion
;		Date :		12th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;			Convert the float in FPA (not tested) to the string buffer
;
; *******************************************************************************************

FloatFloatToString:
		pha
		phx
		phy
		lda 	aExponent 					; is it actually an integer ?
		bne 	_FFTSFloat
		jsr 	FloatIntegerToDecimalString ; if so, just do the integer conversion
		ply
		plx
		pla
		rts

_FFTSFloat:
		+Push32A 							; push A on the stack
		jsr 	FloatInteger				; convert to an integer part.
		jsr 	FloatIntegerToDecimalString ; and convert to a string.
		lda 	#"."						; add decimal point
		jsr 	FloatAddCharacterToBuffer

_FFTSFracLoop:
		+Pop32B 							; pop current value off the stack.
		+Test32B 							; is it zero, if so then exit.
		beq 	_FFTSExit
		+Copy32BA 							; put the value in A
		jsr 	FloatFractional 			; take the fractional part.
		jsr 	FloatNormaliseA 			; normalise it.
		lda 	bExponent 					; if it is a small number stop here
		cmp 	#$DE
		bcc 	_FFTSExit
		lda 	convBufferSize 				; too long a decimal
		cmp 	#15
		bcs 	_FFTSExit
		lda 	#10 						; multiply that by 10.
		+Set32B
		jsr 	FloatMultiply
		+Push32A 							; save result on the stack for the next time round.
		jsr 	FloatInteger				; convert to an integer
		lda 	aMantissa+0 				; output as a digit
		ora 	#48
		jsr 	FloatAddCharacterToBuffer
		bra 	_FFTSFracLoop 				; and go round again.

_FFTSExit:		
		ply
		plx
		pla
		rts