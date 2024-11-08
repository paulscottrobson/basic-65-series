; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		20start.asm
;		Purpose :	Test bed for ifloat code.
;		Date :		5th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

Boot:
		ldx 	#11 						; copy in test data.
-:		lda 	test_float,x
		sta 	aFlags,x
		dex
		bpl 	-

		;jsr 	FloatAdd
		;jsr 	FloatMultiply
		;jsr 	FloatIntDivide
		jsr 	FloatDivide
		
		jmp 	$FFFF




		