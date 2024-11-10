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
;							Multiply iFloat FPA by iFloat FPB 
;
; *******************************************************************************************

FloatMultiply:
		pha 								; save registers
		phx
		phy
		;
		;		Check zero. Ax0 or 0xB => 0 always.
		;
		+Test32A 							; check if FPA = 0
		beq 	_FMExit1 					; if so, just return FPA
		+Test32B 							; check if FPB = 0
		bne 	_FMMultiply 				; if not, do multiply code
		+Clear32A 							; otherwise return zero
_FMExit1:
		ply 								; restore registers
		plx
		pla
		rts		
		;
		;		Floating point multiply, also works as an integer operation, but if integer overflows
		;		it will return a float, which can be detected by a non zero exponents
		;
_FMMultiply:
		clc 								; add FPA exponent to FPB exponent
		lda 	aExponent
		adc 	bExponent
		pha

		lda 	aFlags 						; work out the new sign.
		eor 	bFlags
		and 	#$80
		pha

		+Copy32AR 							; copy FPA into FPR
		+Clear32A 							; zero FPA
		;
		;		Main multiplication loop. FPA is the total, FPB is the additive multiplies, FPR is the right shifting multiplier.
		;
_FMMultiplyLoop:
		lda 	rMantissa+0 				; check LSB of FPR
		and 	#1
		beq 	_FMNoAdd 					

		+Add32AB 							; add FPB to FPA
		bit 	aMantissa+3 				; did we get an overflow ?
		bpl 	_FMNoAdd 					; no, no overflow shift required.
		;
		;		Add overflowed, so shift FPA right rather than doubling FPB. In Integer only this will become a float
		;
		+Shr32A 							; addition on overflow : shift FPA right and bump the exponent.
		inc 	aExponent  					; this replaces doubling the adder FPB
		bra 	_FMShiftR
		;
		;		Double FPB, the value being added in.
		;
_FMNoAdd:		
		bit 	bMantissa+3 				; is it actually possible to double FPB ?
		bvs 	_FMCantDoubleB 		 		; e.g. is bit 30 clear
		+Shl32B 							; if it is clear we can just shift it
		bra 	_FMShiftR
_FMCantDoubleB:
		+Shr32A 							; we can't double FPB so we halve FPA
		inc 	aExponent 					; this fixes the result up.
		;
		;		The usual end of the multiply loop, shift FPR right and loop back if non-zero.
		;
_FMShiftR:		
		+Shr32R 							; shift FPR right.
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
		ply 								; restore registers
		plx
		pla
		rts
