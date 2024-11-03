# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		fractional.py
#		Purpose :	Unary fractional part.
#		Date :		24th October 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,math,random
from ifloat import *
from mathop import *

# *******************************************************************************************
#
#						Fractional part of integer
#
# *******************************************************************************************

class FractionalOperation(UnaryOperation):
	#
	#		Divide two numbers
	#
	def calculate(self,a):
#		print("Calculating",a.get(),"should be",self.getResult(a))
		a.normalise()  																		# Normalise result.
		a.isNegative = False  																# Always positive.
		if a.exponent >= -32:  																# Already a fraction, must be mathematically.
			toStripLeft = a.exponent + 32  													# bits to remove from the left side.
			if toStripLeft >= 32:  															# Definitely an integer, so return zero.
				a = IFloat(0)
			else:
				mask = (0xFFFFFFFF >> toStripLeft)   										# This will be 0000111.... for 4
				a.mantissa = a.mantissa & mask  											# Mask the mantissa.
#		print("Result",a.get())
		return a
	#
	#		Error percent allowed
	#
	def getErrorPercent(self,a):
		return 0.000001
	#
	#		Calculate the actual result.
	#
	def getResult(self,a):
		return abs(a.get()) - int(abs(a.get()))
	#
	#		Validate the input data.
	#
	def validate(self,a):
		return True 

if __name__ == "__main__":
	random.seed(42)
	to = FractionalOperation()	
	for i in range(0,1000*1000):
		to.test(False)
