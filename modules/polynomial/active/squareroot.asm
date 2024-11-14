; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		squareroot.asm
;		Purpose :	Square root function
;		Date :		14th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;						Calculate the square root of FPA. CS on error
;
; *******************************************************************************************

PolySquareRoot:
		pha
		phx
		phy
		bit 	aFlags 						; negative
		sec
		bmi 	_PSRExit 					; if so exit with carry set

		jsr 	PolyLogarithmE 				; Log(FPA)
		dec 	aExponent 					; / 2
		jsr 	PolyExponent 				; Exp(FPA)
		clc
_PSRExit:
		ply
		plx
		pla
		rts

