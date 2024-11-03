# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		ifloat.py
#		Purpose :	iFloat objects
#		Date :		20th October 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,math,random

# *******************************************************************************************
#
#								Class representing a single iFloat.
#
# *******************************************************************************************

class IFloat(object):
	#
	#		Initialise IFloat with given value.
	#
	def __init__(self,newValue = 0):		

		if IFloat.MINVALUE is None:															# Minimum value to feed in.
			IFloat.MINVALUE = 0x7FFFFFFF*pow(2,-127)
			IFloat.MAXVALUE = 0x7FFFFFFF*pow(2,127)

		self.isNegative = False  															# Handle positive/negative numbers
		if newValue < 0:
			self.isNegative = True

		if newValue == int(newValue) and abs(newValue) < 0x80000000:						# Can it be represented as an integer ?
			self.mantissa = abs(int(newValue))
			self.exponent = 0
		else:
			x = self.convert(abs(newValue)) 												# Convert to mantissa and exponent.
			self.mantissa = x[0]
			self.exponent = x[1]
		self.verify()
	#
	#		Check error between two values acceptable.
	#
	def checkRange(self,value,correct,percent):
		if correct == 0:
			isOkay = value <= percent
		elif value == 0:
			isOkay = abs(correct) <= 0.00000001
		else:
			error = abs(correct) * percent / 100.0
			isOkay = abs(correct-value) <= error
		if not isOkay:	
			print("Fails error check should be {0}".format(correct))
			self.dump()
			assert False
	#
	#		IFloat validation
	#
	def verify(self):
		assert self.mantissa < 0x80000000,"Mantissa is out of range"
		assert abs(self.exponent) <= 127,"Exponent is out of range"
		assert not(self.mantissa == 0 and self.isNegative),"Minus zero result"
	#
	#		Get the current value.
	#
	def get(self):
		n = self.mantissa if self.exponent == 0 else self.mantissa* pow(2,self.exponent)
		return -n if self.isNegative else n
	#
	#		Convert a positive number to mantissa and exponent form.
	#
	def convert(self,decimal):
		exponent = int(math.log(decimal,2))
		mantissa = decimal / pow(2.0,exponent)
		while mantissa < 0x40000000:
			mantissa *= 2 
			exponent -= 1
		mantissa = int(mantissa+0.5)
		if (mantissa & 0x80000000) != 0:
			mantissa = mantissa >> 1
			exponent = exponent + 1
		return [mantissa,exponent]
	#
	#		Dump ifloat to stdout
	#
	def dump(self):
		print(self.toString())
	#
	#		Convert to string
	#
	def toString(self):
		return "IFLOAT: {3:16} as {0}${1:08x} . 2^{2}".format("-" if self.isNegative else "+",self.mantissa,self.exponent,self.get())
	#
	#		32 bit twos Complement (helper function)
	#
	def twosComplement(self,n):
		return ((n ^ 0xFFFFFFFF)+1) & 0xFFFFFFFF
	#
	#		Normalise iFloat
	#
	def normalise(self):
		if self.mantissa != 0: 																# Cannot normalise non zero values
			while (self.mantissa & 0x40000000) == 0:
				self.mantissa = self.mantissa << 1
				self.exponent = self.exponent -1
	#
	#		-0 check
	#
	def checkMinusZero(self):
		if self.mantissa == 0:
			self.isNegative = False
		
IFloat.MAXVALUE = None 																		# Minimum/Maximum iFloat value
IFloat.MINVALUE = None

# *******************************************************************************************
#
#								Random integer & float classes
#
# *******************************************************************************************

class RandomIInt(IFloat):
	def __init__(self):
		v = random.randint(-0x7FFFFFFF,0x7FFFFFFF)
		IFloat.__init__(self,v)

class RandomIFloat(IFloat):
	def __init__(self):
		if IFloat.MINVALUE is None:
			IFloat(0)
		v = None
		while v is None:
			s = -1 if random.randint(0,1) == 0 else 1
			v = pow(random.randint(1,1000),random.randint(-100,100)/20)*s
			if v <= IFloat.MINVALUE or v >= IFloat.MAXVALUE:
				v = None
		IFloat.__init__(self,v)


if __name__ == "__main__":
	random.seed(1142)
	for i in range(0,1010):
		print(RandomIFloat().toString())
