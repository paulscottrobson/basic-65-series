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
		lda 	#testString & $FF
		sta 	zTemp0
		lda 	#testString >> 8
		sta 	zTemp0+1

		ldx 	#11 						; copy in test data.
-:		lda 	test_float,x
		sta 	aFlags,x
		dex
		bpl 	-
		stz 	exprStackPtr
		
		;jsr 	FloatAdd
		;jsr 	FloatSubtract
		;jsr 	FloatMultiply
		;jsr 	FloatIntDivide
		;jsr 	FloatDivide
		;jsr 	FloatInteger
		;jsr 	FloatFractional
		
		jsr 	FloatStringToInteger

		jmp 	$FFFF


testString:
		!text 	"32766X"



		