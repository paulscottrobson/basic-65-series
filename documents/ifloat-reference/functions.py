# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		functions.py
#		Purpose :	Trigonometry / Logarithms functions.
#		Date :		12th November 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import random,math

# *******************************************************************************************
#
#									Polynomial base class
#
# *******************************************************************************************

class PolyCalculator(object):
	#
	#		Evaluate a sine polynomial.
	#
	def evaluatePolynomial(self,v,coeff):
		n = 0
		for c in coeff:
			n = n * v
			n = n + c
		return n
	#
	#		Evaluate a factorial
	#
	def factorial(self,n):
		r = 1
		for i in range(1,n+1):
			r = r * i
		return r

# *******************************************************************************************
#
#								Calculate sin(x) in radians
#
# *******************************************************************************************

class SineCalculator(PolyCalculator):
	#
	#		Calculate polynomial function sin(x)
	#
	def calculate(self,r):
		f = r / (2 * math.pi)  															# Divide by 2.Pi, so 0..360 is now range 0..1
		#
		f = abs(f)   																	# Get the fractional part, force into range.
		f = f - math.floor(f)
		quadrant = int(f * 4) 															# quadrant 0-3 work out.
		#
		sign = 1 if r >= 0 else -1  													# sin(-x) = -sin(x)
		if quadrant >= 2:  																# quadrant 2 + 3 are -ve quadrant 1 + 2
			sign = -sign
			f = f - 0.5
		if quadrant == 1 or quadrant == 3: 												# quadrant 1 and 3, flip
			f = 0.5 + (-f)
		#
		sinePoly = []  																	# calculate the sine polynomial
		for i in range(0,5):
			coefficient = 1.0 / self.factorial(i*2+1)
			coefficient = coefficient if (i % 2) == 0 else -coefficient
			coefficient = coefficient * pow(2 * math.pi ,i*2+1)
			sinePoly.insert(0,coefficient)

		result = self.evaluatePolynomial(f*f,sinePoly) * f   							# evaluate using x^2 and multiply by x
		result = result * sign
		return result

# *******************************************************************************************
#
#								Calculate cos(x) in radians
#
# *******************************************************************************************

class CosineCalculator(SineCalculator):
	#
	#		Calculate cos(x) using sin(x)
	#
	def calculate(self,r):
		return SineCalculator.calculate(self,r + math.pi/2)

# *******************************************************************************************
#
#								Calculate tan(x) in radians
#
# *******************************************************************************************

class TangentCalculator(SineCalculator):
	#
	#		Calculate tan(x) using sin(x)/cos(x)
	#
	def calculate(self,r):
		sineValue = SineCalculator.calculate(self,r)
		cosineValue = SineCalculator.calculate(self,r + math.pi/2)
		return None if cosineValue == 0 else sineValue / cosineValue

# *******************************************************************************************
#
#								Calculate arctan(x) in radians
#
# *******************************************************************************************

class ArcTanCalculator(PolyCalculator):
	#
	#		Calculate arctan(x)
	#
	def calculate(self,f):
		#
		adjust = abs(f) >= 1  															# outside range 0..1
		if adjust: 	 																	# if outside range use pi/2-atan(1/f)
			f = 1 / f
		#
		sign = -1 if f < 0 else 1  														# work out sign of result.		
		f = abs(f)
		#
		atanPoly = []  																	# calculate the atan polynomial
		for i in range(0,9):
			coefficient = 1.0 / (i*2+1)
			coefficient = coefficient if (i % 2) == 0 else -coefficient
			atanPoly.insert(0,coefficient)
		#
		result = self.evaluatePolynomial(f*f,atanPoly) * f   							# evaluate using x^2 and multiply by x
		if adjust:
			result = math.pi/2 - result
		#
		result = result * sign  														# put sign back in.
		return result

# *******************************************************************************************
#
#								Calculate log(x)
#
# *******************************************************************************************

class LogCalculator(PolyCalculator):
	#
	#		Calculate polynomial function log(x)
	#
	def calculate(self,r):
		exp = 0  																		# Force into range 1-2 , this can be done fairly easily by manipulating
		while r >= 2:   																# exponents
			r = r / 2
			exp = exp + 1
		while r < 1:
			r = r * 2
			exp = exp - 1

		x = r - 1  																		# taylor series
		logPoly = []
		for i in range(1,14):
			c = 1/i if (i & 1) != 0 else -1/i
			logPoly.insert(0,c)
		r = self.evaluatePolynomial(x,logPoly) * x 
		r = r + math.log(2)*exp
		return r

if __name__ == "__main__":
	random.seed(42)
	#
	#		Sine test
	#
	if False:
		for i in range(-90,90,5):
			a = i / 10
			print("{0:5} {1:8.3f} {2:8.3f} {3:8.3f}".format(a,math.sin(a),SineCalculator().calculate(a),abs(math.sin(a)-SineCalculator().calculate(a))))
		print()
	#
	#		Cosine test
	#
	if False:
		for i in range(-90,90,5):
			a = i / 10
			print("{0:5} {1:8.3f} {2:8.3f} {3:8.3f}".format(a,math.cos(a),CosineCalculator().calculate(a),abs(math.cos(a)-CosineCalculator().calculate(a))))
		print()
	#
	#		Tangent test (only if cos(a) is non-zero)
	#
	if False:
		for i in range(-90,90,5):
			a = i / 10
			if math.cos(a) != 0:
				t = math.tan(a)
				print("{0:5} {1:8.3f} {2:8.3f} {3:8.3f}".format(a,t,TangentCalculator().calculate(a),abs(t-TangentCalculator().calculate(a))))
		print()
	#
	#		Arctangent test 
	#
	if False:
		for i in range(-90,90,5):
			a = i / 10
			t = math.atan(a)
			print("{0:5} {1:8.3f} {2:8.3f} {3:8.3f}".format(a,t,ArcTanCalculator().calculate(a),abs(t-ArcTanCalculator().calculate(a))))
		print()
	#
	#		Log test 
	#
	if True:
		for i in range(5,100,3):
			a = i / 10
			t = math.log(a)
			print("{0:5} {1:8.3f} {2:8.3f} {3:8.3f}".format(a,t,LogCalculator().calculate(a),abs(t-LogCalculator().calculate(a))))
		print()

