; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		02macros_6502.inc
;		Purpose :	Macros (65C02)
;		Date :		5th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

!if CPU=6502 {

; -------------------------------------------------------------------------------------------
;
;								Register to Register copy macro
;
; -------------------------------------------------------------------------------------------

!macro copyreg .target,.source {
	lda 	.source+0
	sta 	.target+0
	lda 	.source+1
	sta 	.target+1
	lda 	.source+2
	sta 	.target+2
	lda 	.source+3
	sta 	.target+3
	lda 	.source+4
	sta 	.target+4
	lda 	.source+5
	sta 	.target+5
}

; -------------------------------------------------------------------------------------------
;
;										Clear A to zero
;
; -------------------------------------------------------------------------------------------
!macro Clear32A {
	jsr 	Clr32A6502
}
; -------------------------------------------------------------------------------------------
;
;									Set A to 32 bit integer in A
;
; -------------------------------------------------------------------------------------------
!macro Set32A {
	jsr 	Set32A6502
}
; -------------------------------------------------------------------------------------------
;
;							Copy B to A as 32 bit integer
;
; -------------------------------------------------------------------------------------------
!macro Copy32BA {
	jsr 	Copy32BA6502
}
; -------------------------------------------------------------------------------------------
;
;							Copy A to R as 32 bit integer
;
; -------------------------------------------------------------------------------------------
!macro Copy32AR {
	jsr 	Copy32AR6502
}
; -------------------------------------------------------------------------------------------
;
;					Add B to A as 32 bit integer, sets N and C 
;
; -------------------------------------------------------------------------------------------
!macro Add32AB {
	jsr 	Add32AB6502
}
; -------------------------------------------------------------------------------------------
;
;					Sub B from A as 32 bit integer, sets N and C 
;
; -------------------------------------------------------------------------------------------
!macro Sub32AB {
	jsr 	Sub32AB6502
}
; -------------------------------------------------------------------------------------------
;
;								Shift A right 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
!macro Shr32A {		
	jsr 	Shr32A6502
}
; -------------------------------------------------------------------------------------------
;
;								Shift B right 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
!macro Shr32B {		
	jsr 	Shr32B6502
}
; -------------------------------------------------------------------------------------------
;
;								Shift R right 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
!macro Shr32R {		
	jsr 	Shr32R6502
}; -------------------------------------------------------------------------------------------
;
;								Shift A left 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
!macro Shl32A {		
	jsr 	Shl32A6502
}
; -------------------------------------------------------------------------------------------
;
;								Shift B left 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
!macro Shl32B {		
	jsr 	Shl32B6502
}
; -------------------------------------------------------------------------------------------
;
;									Check if A is zero
;
; -------------------------------------------------------------------------------------------
!macro Test32A {		
	jsr 	Test32A6502
}
; -------------------------------------------------------------------------------------------
;
;									Check if B is zero
;
; -------------------------------------------------------------------------------------------
!macro Test32B {		
	jsr 	Test32B6502
}
; -------------------------------------------------------------------------------------------
;
;									Check if R is zero
;
; -------------------------------------------------------------------------------------------
!macro Test32R {		
	jsr 	Test32R6502
}
; -------------------------------------------------------------------------------------------
;
;								Negate A, no signs
;
; -------------------------------------------------------------------------------------------
!macro Neg32A {		
	jsr 	Neg32A6502
}

}