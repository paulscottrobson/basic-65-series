; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		multiply.asm
;		Purpose :	Multiplication (int and float)
;		Date :		7th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************
	
; *******************************************************************************************
;
;							Multiply iFloat A by iFloat B 
;
; *******************************************************************************************

FloatMultiply:
		;
		;		Check zero. Ax0 or 0xB => 0 always.
		;
		+Test32A 							; check if A = 0
		beq 	_FMExit1 					; if so, just return A
		+Test32B 							; check if B = 0
		bne 	_FMMultiply 				; if not, do multiply code
		+Clear32A 							; otherwise return zero
_FMExit1:
		rts		
		;
		;		Floating point multiply, also works as an integer operation, but if integer overflows
		;		it will return a float, which can be detected by a non zero exponents
		;
_FMMultiply:
		clc 								; add A exponent to B exponent
		lda 	aExponent
		adc 	bExponent
		pha

		lda 	aFlags 						; work out the new sign.
		eor 	bFlags
		and 	#$80
		pha

		+Copy32AR 							; copy A into R
		+Clear32A 							; zero A
		;
		;		Main multiplication loop. A is the total, B is the additive multiplies, R is the right shifting multiplier.
		;
_FMMultiplyLoop:
		lda 	rMantissa+0 				; check LSB of R
		and 	#1
		beq 	_FMNoAdd 					

		+Add32AB 							; add B to A
		bit 	aMantissa+3 				; did we get an overflow ?
		bpl 	_FMNoAdd 						; no, no overflow shift required.
		;
		;		Add overflowed, so shift A right rather than doubling B. In Integer only this will become a float
		;
		+Shr32A 							; addition on overflow : shift A right and bump the exponent.
		inc 	aExponent  					; this replaces doubling the adder B
		bra 	_FMShiftR
		;
		;		Double B, the value being added in.
		;
_FMNoAdd:		
		bit 	bMantissa+3 				; is it actually possible to double B ?
		bvs 	_FMCantDoubleB 		 		; e.g. is bit 30 clear
		+Shl32B 							; if it is clear we can just shift it
		bra 	_FMShiftR
_FMCantDoubleB:
		+Shr32A 							; we can't double B so we halve A
		inc 	aExponent 					; this fixes the result up.
		;
		;		The usual end of the multiply loop, shift R right and loop back if non-zero.
		;
_FMShiftR:		
		+Shr32R 							; shift R right.
		+Test32R 							; loop back if non-zero
		bne 	_FMMultiplyLoop

_FMExit2:
		pla 								; update the sign and exponent.
		sta 	aFlags
		pla
		clc
		adc 	aExponent
		sta 	aExponent
		jsr 	FloatCheckMinusZero 		; -0 check required here.
		rts
