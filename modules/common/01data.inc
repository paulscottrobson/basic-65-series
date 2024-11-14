; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		01data.inc
;		Purpose :	Data files
;		Date :		5th November 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

		codeAddress = *

; *******************************************************************************************
;
;				Allocate a block of memory without actually initialising it.
;
; *******************************************************************************************

!macro alloc .size {
	* = * + .size
}

; *******************************************************************************************
;
;				Macro to define A/B math registers, which can go in A or B
;
; *******************************************************************************************

		!macro 	MathRegisterSet {

aFlags:
		+alloc 	1
aExponent:		
		+alloc 	1
aMantissa:
		+alloc 	4

bFlags:
		+alloc 	1
bExponent:		
		+alloc 	1
bMantissa:
		+alloc 	4
}

; *******************************************************************************************
;
;										Zero Page
;
; *******************************************************************************************

		* = zeroPageSpace

		!if mathInZeroPage <> 0 {
		+MathRegisterSet
		}

codePtr:
		+alloc	2

dataPtr:
		+alloc	2

stringAddr:
		+alloc	2

basicStackPtr:
		+alloc	2

zTemp0:			
		+alloc	2

zTemp1:			
		+alloc	2

zTemp2:			
		+alloc	2


; *******************************************************************************************
;
;								Non-Zero page data space
;
; *******************************************************************************************

		* = dataSpace

convBufferSize:
		+alloc 	1
convBufferString:
		+alloc 	16

polyCoefficientCount:
		+alloc 	1
polyTempFloat:
		+alloc 	6	
polySign:
		+alloc 	1			
polyFlag:
		+alloc 	1	
polyExponent:
		+alloc 	1				

		!if mathInZeroPage = 0 {
		+MathRegisterSet
		}

rFlags:
		+alloc 	1
rExponent:		
		+alloc 	1
rMantissa:
		+alloc 	4

baseConvert:
		+alloc 	1
modulusLowByte:
		+alloc 	1	
exprStackPtr:
		+alloc 	1
exprStack0:
		+alloc 	exprStackSize
exprStack1:
		+alloc 	exprStackSize
exprStack2:
		+alloc 	exprStackSize
exprStack3:
		+alloc 	exprStackSize
exprStack4:
		+alloc 	exprStackSize
exprStack5:
		+alloc 	exprStackSize

		* = codeAddress

