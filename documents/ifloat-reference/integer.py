# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		integer.py
#		Purpose :	Unary integer part.
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
#						Integer class. Note this does not 'round down'
#
# *******************************************************************************************

class IntegerOperation(UnaryOperation):
	#
	#		Divide two numbers
	#
	def calculate(self,a):
#		print("Calculating",a.get(),"should be",self.getResult(a))
		if a.exponent < 0:  																# Is there a floating part
			a.normalise()   																# Normalise it.
			while a.exponent < 0:  															# Shift to 2^0
				a.mantissa = a.mantissa >> 1
				a.exponent = a.exponent + 1
			a.checkMinusZero()  															# Possible if shifted -0.3
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
		r = int(abs(a.get()))
		return -r if a.get() < 0 else r
	#
	#		Validate the input data.
	#
	def validate(self,a):
		return True 

if __name__ == "__main__":
	random.seed(42)
	to = IntegerOperation()	
#	print(to.calculate(IFloat(122.2)).toString())
	for i in range(0,1000*1000):
		to.test(False)
