# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		divide.py
#		Purpose :	Division
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
#								Division Class
#
# *******************************************************************************************

class DivideOperation(BinaryOperation):
	#
	#		Divide two numbers
	#
	def calculate(self,a,b):
#		print("Calculating",a.get(),b.get(),"should be",self.getResult(a,b))
		a.normalise()
		b.normalise()
		newSign = a.isNegative != b.isNegative  											# Figure out if result is +ve/-ve
		newExponent = a.exponent - b.exponent - 30  										# New exponent.
		r = self.shiftDivide(a,b) 	 														# Divide the two.
		if r.mantissa != 0:  																# Non zero result
			r.isNegative = newSign  														# Set up new sign.
			r.exponent = newExponent
#		print("Result",r.get())
		return r
	#
	#		Integer division with shift
	#
	def shiftDivide(self,a,b):
		r = IFloat(0) 																		# Result.
		for i in range(0,31):																# Do 31 times
			carry = self.divideCheckSubtract(a,b) 											# This is used in integer division also
			# this code is just a 64 bit shift of A:R left
			r.mantissa = (r.mantissa << 1) | (1 if carry else 0) 							# Rotate into result.
			a.mantissa = (a.mantissa << 1) & 0xFFFFFFFF  									# A mantissa left to.
			if (r.mantissa & 0x100000000) != 0:	 											# carry to move.
				r.mantissa = r.mantissa & 0xFFFFFFFF
				a.mantissa = a.mantissa | 1

		return r
	#
	#		Do subtraction, return true if okay.
	#
	def divideCheckSubtract(self,a,b):
		if a.mantissa < b.mantissa:
			return False
		a.mantissa = a.mantissa - b.mantissa
		return True
	#
	#		Error percent allowed
	#
	def getErrorPercent(self,a,b):
		return 0.000001
	#
	#		Calculate the actual result.
	#
	def getResult(self,a,b):
		r = (a.get()+0.0) / b.get()
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
	to = DivideOperation()	
	for i in range(0,1000*1000):
		to.test(False,False)
