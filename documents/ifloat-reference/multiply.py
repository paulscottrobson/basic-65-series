# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		multiply.py
#		Purpose :	Multiplication
#		Date :		22nd October 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,math,random
from ifloat import *
from mathop import *

# *******************************************************************************************
#
#								Multiplication Class
#							 (Result is not normalised)
#
# *******************************************************************************************

class MultiplyOperation(BinaryOperation):
	#
	#		Multiply two numbers
	#
	def calculate(self,a,b):
#		print("Calculating",a.get(),b.get(),"should be",self.getResult(a,b))
		if a.mantissa == 0 or b.mantissa == 0:  											# Short cut for zero
			return IFloat(0)
		exp = a.exponent + b.exponent  														# The new exponent, not allowing for shifts.
		neg = a.isNegative != b.isNegative  												# The new sign.
		a = self.shortMultiply(a,b)  														# Calculate a.b as if the exponents are zero.
		a.exponent = a.exponent + exp  														# Add the shifts required to the new exponent
		a.isNegative = neg

		if a.mantissa == 0:  																# Minus zero fix.
			a.isNegative = False
#		print("Result",a.get())
		return a
	#
	#		Short Multiply, calculates r.b assuming both are zero exponents, shifting if required.
	#
	def shortMultiply(self,a,b):
		r = a  																				# Put A in R
		a = IFloat(0) 																		# Set the result (A) to zero
		while r.mantissa != 0: 																# Typical shift-and-add multiply now ... almost

			mantissaOverflow = False 
			if (r.mantissa & 1) != 0: 														# Bit add in r ?
				a.mantissa = a.mantissa + b.mantissa 	 									# Add b to total
				if (a.mantissa & 0x80000000) != 0: 											# Overflow.
					a.mantissa = a.mantissa >> 1  											# So shift the result right and bump the exponent
					a.exponent = a.exponent + 1
					mantissaOverflow = True 

			if not mantissaOverflow:  														# Not necessary if mantissa has overflowed.
				if (b.mantissa & 0x40000000) != 0: 											# We want to shift B left, but we can't.
					a.mantissa = a.mantissa >> 1  											# So shift the A right and bump the exponent
					a.exponent = a.exponent + 1		
				else:
					b.mantissa = b.mantissa << 1   											# We can, if no normalising.

			r.mantissa = r.mantissa >> 1  													# Shift the R mantissa right
		return a
	#
	#		Error percent allowed
	#
	def getErrorPercent(self,a,b):
		return 0.000001
	#
	#		Calculate the actual result.
	#
	def getResult(self,a,b):
		r = a.get() * b.get()
		return 0 if abs(r) <1e-28 else r

	#
	#		Validate the input data.
	#
	def validate(self,a,b):
		if abs(a.get()) < 1e-10 or abs(b.get()) < 1e-10:
			return False
		result = self.getResult(a,b)
		return result >= IFloat.MINVALUE and result < IFloat.MAXVALUE/8

if __name__ == "__main__":
	random.seed(42)
	to = MultiplyOperation()	
#	print(to.calculate(IFloat(12.7),IFloat(22.3)).toString())
	for i in range(0,1000*1000):
		to.test(False,False)
