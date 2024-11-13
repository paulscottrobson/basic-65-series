; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		utility.asm
;		Purpose :	Utility polynomial functions
;		Date :		13th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;						Load Floating Point value, address following to FPA/FPB.
;
; *******************************************************************************************

PolyCopyFloatA:
		pha 								; save registers
		phx
		phy
		jsr 	PolyCopyFloatCommon			; access following number common code
		ldy 	#5 							; copy data over.
_PCFACopy:
		lda 	(zTemp0),y
		sta 	aFlags,y
		dey
		bpl 	_PCFACopy		

		ply 								; fix up and exit
		plx
		pla
		rts

PolyCopyFloatB:
		pha 								; save registers
		phx
		phy
		jsr 	PolyCopyFloatCommon			; access following number common code
		ldy 	#5 							; copy data over.
_PCFBCopy:
		lda 	(zTemp0),y
		sta 	bFlags,y
		dey
		bpl 	_PCFBCopy		

		ply 								; fix up and exit
		plx
		pla
		rts

PolyCopyFloatCommon:
		tsx

		clc
		lda 	$0106,x 					; LSB of address
		sta 	zTemp0						; save for access
		adc 	#2
		sta 	$0106,x
		lda 	$0107,x 					; same with MSB
		sta 	zTemp0+1
		adc 	#0
		sta 	$0107,x

		ldy  	#1  						; do an indirect read at address + 1
		lda 	(zTemp0),y
		tax
		iny
		lda 	(zTemp0),y
		sta 	zTemp0+1
		stx 	zTemp0
		rts		

		