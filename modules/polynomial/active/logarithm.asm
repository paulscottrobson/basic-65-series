; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		logarithm.asm
;		Purpose :	Natural logarithm evaluation
;		Date :		14th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;					Logarithm calculation of FPA (in Radians). Return CS on error
;
; *******************************************************************************************

PolyLogarithmE:
		pha
		phx
		phy
		lda 	aFlags 						; if negative, it's bad
		sec 								; so return with CS.
		bmi 	_PLEExit

		jsr 	FloatNormaliseA 			; normalise, might be integer

;		lda 	#$E2 						; force into range 1-2.
;		sta 	aExponent

		clc
_PLEExit:
		ply
		plx
		pla
		rts

