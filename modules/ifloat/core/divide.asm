; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		divide.asm
;		Purpose :	Division (int and float, which are seperate)
;		Date :		8th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************
	
; *******************************************************************************************
;
;							  Divide iFloat A by iFloat B (float)
;								   (CS on division by zero)
;
; *******************************************************************************************

FloatDivide: 		
		;
		;		Check division by zero.
		;
		+Test32B 							; check if B = 0
		bne 	_FMFDivide 					; if not, do divide
		sec
		rts		
		;
		;		FP Divide
		;
_FMFDivide:
		jsr 	FloatNormaliseA 			; normalise A & B 					
		jsr 	FloatNormaliseB 					

		lda 	aFlags 						; calculate new sign and push on stack
		eor 	bFlags
		pha
		;
		sec 								; calculate new exponent
		lda 	aExponent
		sbc 	bExponent
		sec
		sbc 	#30
		pha

		jsr 	_FFDMain 					; the main float division routine
		+Copy32RA 							; A := R

		pla 								; restore exponent.
		sta 	aExponent 			
		pla  								; restore sign.
		and 	#$7F
		sta 	aFlags

		jsr 	FloatCheckMinusZero 		; -0 check required here.
		clc 								; valid result
		rts
;
;		Main FP Division routine.
;
_FFDMain:
		ldx 	#5 							; clear R
_FFDClearR:
		stz 	rFlags,x
		dex
		bpl 	_FFDClearR

		lda 	#31 						; Main loop counter
_FFDLoop:
		pha 								; save counter.
		jsr 	FloatDivTrySubtract 		; try to subtract
		php 								; save the result
		jsr 	FloatDivShiftARLeft 		; shift A:R left one.
		plp 								; restore the result
		bcc 	_FFDFail 					; could not subtract
		inc 	rMantissa+0 				; set bit 0 (cleared by shift left)
_FFDFail:
		pla 								; pull and loop
		dec 	
		bne 	_FFDLoop
		rts

; *******************************************************************************************
;
;							Divide iFloat A by iFloat B (integer) 
;								   (CS on division by zero)
;
; *******************************************************************************************

FloatIntDivide: 							; it's integer division in the Float package !!
		;
		;		Check division by zero.
		;
		+Test32B 							; check if B = 0
		bne 	_FMDivide 					; if not, do divide code
		sec
		rts		
		;
		;		Integer Divide.
		;
_FMDivide:
		lda 	aFlags 						; calculate new sign and push on stack
		eor 	bFlags
		pha
		jsr 	_FIDMain 					; the main integer division routine
		+Copy32RA 							; A := R
		pla  								; restore sign.
		and 	#$7F
		sta 	aFlags

		jsr 	FloatCheckMinusZero 		; -0 check required here.
		clc 								; valid result
		rts
;
;		Main integer division routine.
;
_FIDMain:
		+Copy32AR 							; R := A
		+Clear32A 							; A := 0
		lda 	#32 						; Main loop counter
_FIDLoop:
		pha 								; save counter.
		jsr 	FloatDivShiftARLeft 		; shift A:R left one.
		jsr 	FloatDivTrySubtract 		; try to subtract
		bcc 	_FIDFail 					; could not subtract
		inc 	rMantissa+0 				; set bit 0 (cleared by shift left)
_FIDFail:
		pla 								; pull and loop
		dec 	
		bne 	_FIDLoop
		rts

; *******************************************************************************************
;
;									Shift A:R left one
;
; *******************************************************************************************

FloatDivShiftARLeft:
		asl 	rMantissa+0 				; do the lower byte .... 	
		rol 	rMantissa+1
		rol 	rMantissa+2
		rol 	rMantissa+3
		rol 	aMantissa+0 				; the upper byte. This is only used in divide so
		rol 	aMantissa+1 				; it's not really worth optimising. 
		rol 	aMantissa+2
		rol 	aMantissa+3
		rts

; *******************************************************************************************
;
;						Try to subtract B from A. If it works, return CS
;
; *******************************************************************************************

FloatDivTrySubtract:
		+Sub32AB 							; subtract B from A
		bcs 	_FDTSExit 					; it worked okay.
		+Add32AB 							; failed, so write it back
		clc 								; carry must be clear.
_FDTSExit:
		rts		

