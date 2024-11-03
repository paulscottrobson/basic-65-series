# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		add.py
#		Purpose :	Addition (and subtraction)
#		Date :		21st October 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,math,random
from ifloat import *
from mathop import *

# *******************************************************************************************
#
#								Addition Class
#
#	  Subtraction is just addition with the second value having a negated first paremeter
#
# *******************************************************************************************

class AddOperation(BinaryOperation):
	#
	#		Add two numbers
	#
	def calculate(self,a,b):
#		print("Adding",a.get(),b.get())
		if a.mantissa == 0:  																# Handle adding zero.
			return b
		if b.mantissa == 0:
			return a

		if a.isNegative == b.isNegative:  													# Are the signs the same (it's an ADD)
			result = self.addMantissa(a,b)   												# Add mantissae
		else:  																				# Signs are different, (it's a SUB)
			result = self.subtractMantissa(a,b)  											# Calculate a - b
		a.checkMinusZero()
#		print("Making",result.get())
		return result 
	#
	#		Add 2 mantissa 
	#
	def addMantissa(self,a,b):
		if a.exponent == 0 and b.exponent == 0:
			return self.addIntegerMantissa(a,b)
		else:
			return self.addFloat(a,b)
	#
	#		Subtract mantissa (e.g. a-b) 
	#
	def subtractMantissa(self,a,b):
		if a.exponent == 0 and b.exponent == 0:
			return self.subtractIntegerMantissa(a,b)
		else:
			return self.subtractFloat(a,b)
	#
	#		Add 2 floating point values
	#
	def addFloat(self,a,b):
		a.normalise()  																		# Normalise both.		
		b.normalise()
		targetExponent = max(a.exponent,b.exponent)  										# We want things to go to this exponent, the higher of the two.
		self._shiftToTarget(a,targetExponent)												# Make them the same exponent.
		self._shiftToTarget(b,targetExponent)
		a.mantissa = a.mantissa + b.mantissa  												# Calculate the sum.
		if (a.mantissa & 0x80000000) != 0: 													# Mantissa overflow, fix up.
			a.mantissa = a.mantissa >> 1
			a.exponent = a.exponent + 1
		a.checkMinusZero()
		return a
	#
	#		Subtract 2 floating point values. Very similar to add, so can share code.
	#
	def subtractFloat(self,a,b):
		a.normalise()  																		# Normalise both.		
		b.normalise()
		targetExponent = max(a.exponent,b.exponent)  										# We want things to go to this exponent, the higher of the two.
		self._shiftToTarget(a,targetExponent)												# Make them the same exponent.
		self._shiftToTarget(b,targetExponent)
		a.mantissa = (a.mantissa + b.twosComplement(b.mantissa)) & 0xFFFFFFFF				# calculate the result
		if (a.mantissa & 0x80000000) != 0: 													# Negative result.
			a.mantissa = a.twosComplement(a.mantissa)
			a.isNegative = not a.isNegative
		a.checkMinusZero()
		return a
	#
	#		Helper function : shift an iFloat to the given exponent.
	#
	def _shiftToTarget(self,a,target):
		assert a.exponent <= target
		while a.exponent < target: 															# shift right until in same exponent
			a.mantissa = a.mantissa >> 1
			a.exponent = a.exponent + 1	
	#
	#		Add 2 mantissa as absolute values (integer version)
	#
	def addIntegerMantissa(self,a,b):		
		a.mantissa = a.mantissa + b.mantissa  												# Add the mantissa
		a.exponent = 0
		if (a.mantissa & 0x80000000) != 0:													# Overflow result ?
			a.mantissa = a.mantissa >> 1  													# Shift right and bump exponent
			a.exponent = 1 																	# Can't fit in integer so make it a float
		return a 
	#
	#		Subtract mantissa (e.g. a-b) as absolute values (integer version)
	#
	def subtractIntegerMantissa(self,a,b):	
		a.mantissa = (a.mantissa + b.twosComplement(b.mantissa)) & 0xFFFFFFFF				# calculate the result
		a.exponent = 0
		if a.mantissa & 0x80000000 != 0:  													# If result -ve (would test sign bit in 2's complement
			a.mantissa = a.twosComplement(a.mantissa)
			a.isNegative = not a.isNegative
		return a
	#
	#		Error percent allowed
	#
	def getErrorPercent(self,a,b):
		return 0.00002
	#
	#		Calculate the actual result.
	#
	def getResult(self,a,b):
		return a.get()+b.get()
	#
	#		Validate the input data.
	#
	def validate(self,a,b):
		result = a.get()+b.get()
		return result >= IFloat.MINVALUE and result < IFloat.MAXVALUE

if __name__ == "__main__":
	random.seed(42)
	to = AddOperation()
#	r = to.calculateFloat(IFloat(1903998632),IFloat(1.54207332572e-14))
#	r.dump()
	for i in range(0,1000*1000):
		to.test(False,False)
