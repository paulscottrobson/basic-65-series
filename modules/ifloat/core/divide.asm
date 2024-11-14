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
;							  Divide iFloat FPA by iFloat FPB (float)
;								   (CS on division by zero)
;
; *******************************************************************************************

FloatDivide: 		
		pha 								; save registers
		phx
		phy
		;
		;		Check division by zero.
		;
		+Test32B 							; check if FPB = 0
		bne 	_FMFDivide 					; if not, do divide
		ply 								; restore registers
		plx
		pla
		sec
		rts		
		;
		;		FP Divide
		;
_FMFDivide:
		jsr 	FloatNormaliseA 			; normalise FPA & FPB 					
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
		+Copy32RA 							; FPA := FPR

		pla 								; restore exponent.
		sta 	aExponent 			
		pla  								; restore sign.
		and 	#$80
		sta 	aFlags

		jsr 	FloatCheckMinusZero 		; -0 check required here.
		ply 								; restore registers
		plx
		pla
		clc 								; valid result
		rts
;
;		Main FP Division routine.
;
_FFDMain:
		ldx 	#5 							; clear FPR
_FFDClearR:
		stz 	rFlags,x
		dex
		bpl 	_FFDClearR

		lda 	#31 						; Main loop counter
_FFDLoop:
		pha 								; save counter.
		jsr 	FloatDivTrySubtract 		; try to subtract
		php 								; save the result
		jsr 	FloatDivShiftARLeft 		; shift FPA:FPR left one.
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
;			Divide iFloat A by iFloat B (integer) . Inputs not checked for integer-ness
;								   (CS on division by zero)
;
; *******************************************************************************************

FloatIntDivide: 							; it's integer division in the Float package !!
		pha 								; save registers
		phx
		phy
		;
		;		Check division by zero.
		;
		+Test32B 							; check if FPB = 0
		bne 	_FMDivide 					; if not, do divide code
		ply 								; restore registers
		plx
		pla
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
		lda 	aMantissa 					; save the LSB of the remainder for later
		sta 	modulusLowByte		
		+Copy32RA 							; FPA := FPR
		pla  								; restore sign.
		and 	#$7F
		sta 	aFlags

		jsr 	FloatCheckMinusZero 		; -0 check required here.
		ply 								; restore registers
		plx
		pla
		clc 								; valid result
		rts
;
;		Main integer division routine.
;
_FIDMain:
		+Copy32AR 							; FPR := FPA
		+Clear32A 							; FPA := 0
		lda 	#32 						; Main loop counter
_FIDLoop:
		pha 								; save counter.
		jsr 	FloatDivShiftARLeft 		; shift FPA:FPR left one.
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
;									Shift FPA:FPR left one
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
;						Try to subtract FPB from FPA. If it works, return CS
;
; *******************************************************************************************

FloatDivTrySubtract:
		+Sub32AB 							; subtract FPB from FPA
		bcs 	_FDTSExit 					; it worked okay.
		+Add32AB 							; failed, so add it back
		clc 								; carry must be clear.
_FDTSExit:
		rts		

