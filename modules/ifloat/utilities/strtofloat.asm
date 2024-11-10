; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		strtofloat.asm
;		Purpose :	Convert value at (zTemp0) to a floating point number in A
;		Date :		8th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;					Convert string at (zTemp0) into FPA. Return CS on error.
;		 Behaves like VAL() in that it does not have a problem with ending bad characters
;
; *******************************************************************************************

FloatStringToFloat:
		pha 								; save registers
		phx
		phy
		;
		;		Process possible preceding '-'
		;
		lda 	(zTemp0) 					; get, and push, the first character.
		eor 	#"-"						; will be $00 if it is '-', non zero otherwise
		beq 	_FSTFNoFlip
		lda 	#$80 						; $00 => '-', $80 => positive
_FSTFNoFlip:		
		eor 	#$80 						; now a sign bit.
		pha 								; save it.
		beq 	_FSTFNoMinus 				; if was +ve don't bump
		inc 	zTemp0  					; if it was '-' advance the pointer.
		bne 	_FSTFNoMinus				
		inc 	zTemp0+1
_FSTFNoMinus:
		;
		;		The integer part, if there is one.
		;
		+Clear32A 							; zero FPA
		ldy 	#1 							; this is the amount to skip if decimal.
		lda 	(zTemp0) 					; is it '.xxxxx' VAL(".12") => 0.12
		cmp 	#"."						; if so, convert to decimal.
		beq 	_FSTFDecimalPart

		jsr 	FloatStringToInteger 		; get the integer part first.
		bcs 	_FSTFExit 					; bad number.
		tay 								; count of characters in Y
		lda 	(zTemp0),y 					; what follows is '.'
		cmp 	#'.' 						; if not, then exit with a whole number and carry clear
		bne 	_FSTFExitOkay
		iny
		;
		;		The fractional part, if there is one.
		;
_FSTFDecimalPart:
		tya 								; point zTemp0 to post decimal point bit.
		clc
		adc 	zTemp0
		sta 	zTemp0
		bcc 	_FSTFNoCarry
		inc 	zTemp0+1
_FSTFNoCarry:		
		lda 	(zTemp0) 					; character following, if illegal just ignore it.
		cmp 	#'0' 						; VAL("12.") => 12
		bcc 	_FSTFExitOkay
		cmp 	#'9'+1
		bcs 	_FSTFExitOkay
		+Push32A 							; push FPA on the stack.
		jsr 	FloatStringToInteger 		; get the Decimal Point bit, divisor is in A
		bcs 	_FSTFExit 					; bad number.
		jsr 	FloatScale10 				; divide by 10^A
		+Pop32B 				 			; FPA is fractional part, FPB integer part
		jsr 	FloatAdd 					; add them together.
_FSTFExitOkay:
		pla 								; get flags
		sta 	aFlags
		clc 								; result is okay.
_FSTFExit:		
		ply 								; restore registers
		plx
		pla
		rts				

