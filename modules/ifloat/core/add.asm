; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		add.asm
;		Purpose :	Addition/Subtraction
;		Date :		6th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;							Subtract iFloat B from iFloat A
;
; *******************************************************************************************

FloatSubtract:
		lda 	bFlags 						; toggle the sign of B and add.
		eor 	#$80
		sta 	bFlags
		
; *******************************************************************************************
;
;							Add iFloat B to iFloat A (also used for subtract)
;
; *******************************************************************************************

FloatAdd:
		lda 	aExponent 					; check if both integer
		ora 	bExponent
		bmi 	_FAFloatingPoint 			; if either has a non-zero exponent it's a FP calculation.

		lda 	aFlags 						; are they different sign flags
		eor 	bFlags 						; e.g. the signs are different, it's a subtraction
		bmi 	_FASubtraction
		;
		;		Integer arithmetic : Addition
		;
		+Add32AB  							; add B to A - sign of result is inherited.
		bpl 	_FAExit 					; no overflow, bit 31 of mantissa clear.
		+Shr32A 							; fix up the mantissa
		inc 	aExponent 					; bump the exponent
		bra 	_FAExit 					; and quit.
		;
		;		Integer arithmetic : Subtraction
		;	
_FASubtraction:
		+Sub32AB 							; subtract B from A
		bpl 	_FAExit 					; no underflow, then exit.
		+Neg32A 							; negate A mantissa 
		lda 	aFlags 						; toggle the sign flag
		eor 	#$80
		sta 	aFlags
		;
		;		Exit, with check for minus zero.
		;
_FAExit:
		; TODO: Check for minus zero.
		rts		
		;
		;		Floating point add/subtract
		;
_FAFloatingPoint:
		!byte 	$DB

		

