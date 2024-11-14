; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		tangent.asm
;		Purpose :	Tangent evaluation
;		Date :		14th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;					Tangent calculation of FPA (in Radians). Return CS on error
;
; *******************************************************************************************

PolyTangent:
		pha
		phx
		phy

		+Push32A 							; save FPA on stack
		jsr 	PolyCosine 					; FPA is cos(x)
		+Pop32B 							; FPA is cos(x) FPB (x)
		+Push32A 							; FPB is x, cos(x) on stack
		+Copy32BA 							; FPA is x, cos(x) on stack
		jsr 	PolySine 					; FPA is sin(x), cos(x) on stack
		+Pop32B 							; FPA is sin(x), FPB is cos(x)

		+Test32B 							; check cos(x) is zero.
		sec 								; if so exit with carry set.
		beq 	_PTExit
		jsr 	FloatDivide 				; work out tangent
		clc 								; no error.
_PTExit:		
		ply
		plx
		pla
		rts

