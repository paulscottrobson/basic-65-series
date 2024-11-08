; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		scale10.asm
;		Purpose :	Divide A by 10^A
;		Date :		8th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;										Divide A by 10^A
;
; *******************************************************************************************

FloatScale10:
		pha
		phx
		phy

		cmp	 	#16 						; divider >= 16
		bcs 	_FSCZero 					; return zero.

		sta 	bMantissa 					; temporary store, we want to x 3
		asl 	 							; x 2
		adc 	bMantissa 					; x 3
		asl 	 							; x 6
		tax
		ldy 	#0 							; index into B
_FSCCopy:
		lda 	FloatScalarTable,x 			; copy it
		sta 	bFlags,y
		inx
		iny
		cpy 	#6 							; copied 6 bytes of float data
		bne 	_FSCCopy
		jsr 	FloatMultiply 				; the scalars are 1, 0.1 etc.
		bra 	_FSCExit

_FSCZero:
		+Clear32A 							; set the A register to zero.
_FSCExit:		
		ply 								; restore registers
		plx
		pla
		rts				

