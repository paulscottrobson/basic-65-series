# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		intdiv.py
#		Purpose :	IntegerDivision
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
#							Integer only Division Class
#
# *******************************************************************************************

class IntegerDivideOperation(BinaryOperation):
	#
	#		Divide two numbers
	#
	def calculate(self,a,b):
#		print("Calculating",a.get(),b.get(),"should be",self.getResult(a,b))
		newSign = a.isNegative != b.isNegative  											# Figure out if result is +ve/-ve
		a = self.shiftDivide(a,b) 	 														# Divide the two.
		if a.mantissa != 0:  																# Non zero result
			a.isNegative = newSign  														# Set up new sign.
#		print("Result",a.get())
		return a
	#
	#		Integer division
	#
	def shiftDivide(self,r,b):
		a = IFloat(0)
		for i in range(0,32):																# Do 31 times
			# this code is just a 64 bit shift of A:R left
			r.mantissa = (r.mantissa << 1) 						 							# Shift R
			a.mantissa = (a.mantissa << 1) & 0xFFFFFFFF  									# A mantissa left too.
			if (r.mantissa & 0x100000000) != 0:	 											# carry to move.
				r.mantissa = r.mantissa & 0xFFFFFFFF
				a.mantissa = a.mantissa | 1
			if self.divideCheckSubtract(a,b):  												# Can subtract ?
				r.mantissa = r.mantissa | 1  												# Set LSB of R
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
		return 0
	#
	#		Calculate the actual result.
	#
	def getResult(self,a,b):
		r = int(abs(int(a.get())) / abs(int(b.get())))
		return -r if a.get()*b.get() < 0 else r

	#
	#		Validate the input data.
	#
	def validate(self,a,b):
		if b.get() == 0:
			return False
		return self.getResult(a,b)

if __name__ == "__main__":
	random.seed(42)
	to = IntegerDivideOperation()	
	#print(to.calculate(IFloat(122),IFloat(2)).toString())
	for i in range(0,1000*1000):
		to.test(True,False)
