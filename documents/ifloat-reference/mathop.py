# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		mathop.py
#		Purpose :	Mathematical Operation Base Classes
#		Date :		21st October 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,math,random
from ifloat import *

# *******************************************************************************************
#
#								Operation Class
#
# *******************************************************************************************

class MathOperation(object):	

	def getRandomInteger(self):
		a = RandomIInt()
		if random.randint(0,2) == 0:
			a = IFloat(random.randint(-100,100))
		if random.randint(0,9) == 0:
			a = IFloat(0)
		return a

	def getRandomFloat(self):
		if random.randint(0,3) == 0:
			x = self.getRandomInteger()
		elif random.randint(0,2) != 0:
			x = IFloat(random.randint(-100000,100000)/100.0)
		else:
			x = RandomIFloat()
		return x

# *******************************************************************************************
#
#							   Unary Operation Class
#
# *******************************************************************************************

class UnaryOperation(MathOperation):
	#
	#		Do one test
	#
	def test(self,forceInteger = False,forcePositive = False):

		isOk = False  																		# Get two valid values, both may be integers
		while not isOk:
			if forceInteger:
				a = self.getRandomInteger()
			else:
				a = self.getRandomFloat()

			if forcePositive:
				a.isNegative = False
			isOk = self.validate(a)

#		print("------------------	")
#		a.dump()
#		b.dump()

		correct = self.getResult(a)		
		error = self.getErrorPercent(a)

		calculated = self.calculate(a)  													# Calculate result. This normally changes a
#		calculated.dump()
		calculated.verify()   																# Is it a legal float
		calculated.checkRange(calculated.get(),correct,error)  								# Check the answer.

# *******************************************************************************************
#
#							   Binary Operation Class
#
# *******************************************************************************************

class BinaryOperation(MathOperation):
	#
	#		Do one test
	#
	def test(self,forceInteger = False,forcePositive = False):

		isOk = False  																		# Get two valid values, both may be integers
		while not isOk:
			if forceInteger:
				a = self.getRandomInteger()
				b = self.getRandomInteger()
			else:
				a = self.getRandomFloat()
				b = self.getRandomFloat()

			if forcePositive:
				a.isNegative = False
				b.isNegative = False

			isOk = self.validate(a,b)

#		print("------------------	")
#		a.dump()
#		b.dump()

		isInteger = a.exponent == 0 and b.exponent == 0  									# Error allowed. If both values are integers error is zero.
		correct = self.getResult(a,b)		
		error = self.getErrorPercent(a,b)

		calculated = self.calculate(a,b)  													# Calculate result. This normally changes a & b
#		calculated.dump()
		calculated.verify()   																# Is it a legal float
		calculated.checkRange(calculated.get(),correct,error)  								# Check the answer.
