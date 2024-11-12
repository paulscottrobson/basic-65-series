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
		sta 	baseConvert 				; save the base to convert

		stz 	convBufferSize 				; clear the buffer, both NULL terminated and length prefixed.
		stz 	convBufferString

		bit 	aFlags 						; -ve ?
		bpl 	_FITSPositive
		stz 	aFlags 						; not really required :)
		lda 	#'-' 						; output -
		jsr 	FloatAddCharacterToBuffer
_FITSPositive:		
		jsr 	_FITSRecursive
		ply 								; restore registers
		plx
		pla
		rts				

_FITSRecursive:
		lda 	baseConvert 				; divide by the base, put in B
		+Set32B 						
		jsr 	FloatIntDivide  			; integer division.
		lda 	modulusLowByte 				; get the low byte, the remainder and save it.
		pha
		+Test32A 							; zero ?
		beq 	_FITSZero
		jsr 	_FITSRecursive 				; if not, keep going.
_FITSZero:
		pla
		cmp 	#10 						; hexadecimal or higher ?
		bcc 	_FITSNotHex
		clc
		adc 	#7
_FITSNotHex:
		clc 								; make ASCII.
		adc 	#48
		jsr 	FloatAddCharacterToBuffer 	; add to buffer and exit
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
