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
		r = self.shortMultiply(a,b)  														# Calculate a.b as if the exponents are zero.
		r.exponent = r.exponent + exp  														# Add the shifts required to the new exponent
		if r.mantissa != 0:  																# Apply new sign *only* if not zero.
			r.isNegative = neg
#		print("Result",r.get())
		return r
	#
	#		Short Multiply, calculates a.b assuming both are zero exponents, shifting if required.
	#
	def shortMultiply(self,a,b):
		r = IFloat(0) 																		# Set the result to zero
		while b.mantissa != 0: 																# Typical shift-and-add multiply now ... almost

			mantissaOverflow = False 
			if (b.mantissa & 1) != 0: 														# Bit add in b ?
				r.mantissa = r.mantissa + a.mantissa  										# Add a to total
				if (r.mantissa & 0x80000000) != 0: 											# Overflow.
					r.mantissa = r.mantissa >> 1  											# So shift the result right and bump the exponent
					r.exponent = r.exponent + 1
					mantissaOverflow = True 

			if not mantissaOverflow:  														# Not necessary if mantissa has overflowed.
				if (a.mantissa & 0x40000000) != 0: 											# We want to shift A left, but we can't.
					r.mantissa = r.mantissa >> 1  											# So shift the result right and bump the exponent
					r.exponent = r.exponent + 1		
				else:
					a.mantissa = a.mantissa << 1   											# We can, if no normalising.

			b.mantissa = b.mantissa >> 1  													# Shift the B mantissa right
		return r
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
