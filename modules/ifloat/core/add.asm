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
		beq 	_FAInteger 					; if so, don't need to normalise
		;
		;		Check zero.
		;
		+Test32B 							; check if B = 0
		beq 	_FAExit 					; if so, just return A.
		+Test32A 							; check if A = 0
		bne 	_FAFloatingPoint 			; if not, then do FP addition.
		+Copy32BA 							; copy B to A
		bra 	_FAExit 					; and exit
		;
		;		Floating point add/subtract
		;
_FAFloatingPoint:
		jsr 	NormaliseA 					; normalise A & B 					
		jsr 	NormaliseB 					
		;
		;		Work out the common exponent for the arithmetic.
		;
		lda 	aExponent 					; calculate the higher exponent, to X
		tax
		cmp 	bExponent 					; signed comparison
		bvc		+
		eor 	#$80
+		bpl 	+
		ldx 	bExponent 					; get the lower value.
+		
		;
		;		Shift both mantissa/exponent to match X in A
		;
- 		cpx 	aExponent 					; reached required exponent (A)
		beq 	+
		phx
		+Shr32A 							; shift right and adjust exponent, preserving the target
		plx
		inc 	aExponent
		bra 	-
+			
		;
		;		Shift both mantissa/exponent to match X in B
		;
- 		cpx 	bExponent 					; reached required exponent (B)
		beq 	+
		phx
		+Shr32B 							; shift right and adjust exponent, preserving the target
		plx
		inc 	bExponent
		bra 	-
+								
		;
		;		Now do the mantissa add/subtract and adjustment, figure out which first.
		;					
_FAInteger:
		lda 	aFlags 						; are they different sign flags
		eor 	bFlags 						; e.g. the signs are different, it's a subtraction
		bmi 	_FASubtraction
_FAAddition:
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
		bra 	_FAExit
		;
		;		Exit, with check for minus zero - fall through here.
		;
_FAExit:

; *******************************************************************************************
;
;									Normalise A & B
;
; *******************************************************************************************

FloatCheckMinusZero:
		+Test32A 							; if a zero mantissa
		bne 	_FCMZExit
		lda 	aFlags 						; clear the sign bit
		and 	#$7F
		sta 	aFlags
_FCMZExit:				
		rts		


		bra 	_FAExit

; *******************************************************************************************
;
;									Normalise A & B
;
; *******************************************************************************************

NormaliseA:
		+Test32A 							; check A zero
		beq 	_NAExit		
-:
		lda 	aMantissa+3 				; check normalised
		and 	#$40
		bne 	_NAExit		
		+Shl32A
		dec 	aExponent
		bra 	-
_NAExit:
		rts				
		
NormaliseB:
		+Test32B 							; check A zero
		beq 	_NBExit
-:
		lda 	bMantissa+3 				; check normalised
		and 	#$40
		bne 	_NBExit		
		+Shl32B
		dec 	bExponent
		bra 	-
_NBExit:
		rts				

