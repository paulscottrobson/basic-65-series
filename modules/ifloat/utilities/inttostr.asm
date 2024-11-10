; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		inttostr.asm
;		Purpose :	Integer to String conversion.
;		Date :		10th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;			Convert the integer in FPA (not tested) to Decimal in the string buffer
;
; *******************************************************************************************

FloatIntegerToDecimalString:
		pha
		lda 	#10
		jsr 	FloatIntegerToString
		pla
		rts

; *******************************************************************************************
;
;					Convert the integer in FPA to a String in Base A
;
; *******************************************************************************************

FloatIntegerToString:
		pha 								; save registers
		phx
		phy

		stz 	convBufferSize 				; clear the buffer, both NULL terminated and length prefixed.
		stz 	convBufferString

		ply 								; restore registers
		plx
		pla
		rts				

; *******************************************************************************************
;
;					Add Character to Buffer (also used by FloatFloatToString)
;
; *******************************************************************************************

FloatAddCharacterToBuffer:
		phx
		ldx 	convBufferSize 				; current size
		sta 	convBufferString,x 			; write character out
		stz 	convBufferString+1,x 		; make ASCIIZ
		inc 	convBufferSize 				; bump character count
		plx
		rts
