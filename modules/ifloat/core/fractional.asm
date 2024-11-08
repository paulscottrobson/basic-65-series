; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		fractional.asm
;		Purpose :	Fractional part of a number
;		Date :		8th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;							Get fractional part of A
;
; *******************************************************************************************

FloatFractional:
		pha 								; save registers
		phx
		phy
		jsr 	FloatNormaliseA 			; normalise A
		stz 	aFlags 						; take absolute value of A

		lda 	aExponent 					; check exponent
		bpl 	_FFZero 					; if >= 0 then return zero.
		cmp 	#$E0+1 						; if it is <= -32 ($E0) it is already fractional, e.g. $80...$E0 inclusive
		bcc 	_FFExit
		clc
		adc 	#32 						; this is the number of bits to strip - must be >= 0 (from MSB)
		tax 								; which goes into X.
		ldy 	#3 							; offset into a Mantissa, starts with MSB
_FFStripBits:
		cpx 	#0 							; done ?
		beq 	_FFExit
		cpx 	#8 							; 8 or more bits to strip.		
		bcs 	_FFStripByte  				; do a byte at a time.

		lda 	aMantissa,y 				; do the final bit strip.
		and 	_FFBitStrip,x
		sta 	aMantissa,y
		bra 	_FFExit 					; and exit

_FFStripByte:
		lda 	#0 							; strip a whole byte
		sta 	aMantissa,y
		dey 								; next most significant byte
		txa 								; subtract 8 from the todo count 
		sec
		sbc 	#8
		tax
		bra 	_FFStripBits 				; and go round again.

_FFZero:
		+Clear32A 							; return 0
_FFExit:
		ply 								; restore registers
		plx
		pla
		rts				

_FFBitStrip:	
		!byte 	$FF 						; 0
		!byte 	$7F 						; 1
		!byte 	$3F 						; 2
		!byte 	$1F 						; 3
		!byte 	$0F 						; 4
		!byte 	$07 						; 5
		!byte 	$03 						; 6
		!byte 	$01 						; 7
		!byte 	$00 						; 8
