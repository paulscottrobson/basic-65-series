; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		integer.asm
;		Purpose :	Integer part of a number
;		Date :		8th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;							Get integer part of A
;
; *******************************************************************************************

FloatInteger:
		lda 	aExponent 					; exponent >= 0, then already integer
		bpl 	_FIExit
		+Test32A 							; zero, then integer
		beq 	_FIExit
		jsr 	FloatNormaliseA 			; Normalise A
_FIConvert:		
		lda 	aExponent 					; exponent sill negative ?
		bpl 	_FIExit
		+Shr32A 							; keep shifting right until exponent = 0
		inc 	aExponent
		bra 	_FIConvert
_FIExit:
		jsr 	FloatCheckMinusZero 		; -0 check required here.
		rts				

