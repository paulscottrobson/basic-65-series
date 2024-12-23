; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		dummy.asm
;		Purpose :	Dummy polynomial functions
;		Date :		13th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;							Dummy Polynomial evaluation stubs
;
; *******************************************************************************************

PolyCosine:
PolySine:
PolyTangent:		
PolyArcTangent:
PolyLogarithmE:
PolyExponent:
PolySquareRoot:
		+Clear32A 							; return zero as not implemented
		sec 								; they always fail, even though some actually can't theoretically.	
		rts