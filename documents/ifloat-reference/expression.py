# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		expression.py
#		Purpose :	Expression evaluator (does not use iFloats)
#		Date :		25th October 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,math,random

# *******************************************************************************************
#
#								Expression evaluator class
#
#	This is very simplified. Only operators are +, * and ^. Only term is a single digit
#
# *******************************************************************************************

class ExpressionEvaluator(object):
	def __init__(self):
		self.a = 0  																		# the two static registers. Not using a stack.
		self.b = 0
		self.precedence = { "^":1, "+":2, "*": 3 }  										# Operator precedence table.
	#
	#		Evaluate a string expression consisting of a mix of single digit numbers, ^ + and * operators only.
	#	
	def evaluate(self,expr):
		self.expr = [x for x in expr] 														# Split expression into parts
		self.stack = []  																	# Empty stack.
		self.evaluateRecursive(0)  															# Recursive evaluation to 'A' at the base level
		return self.a
	#
	#		Recursive evaluation code.
	#
	def evaluateRecursive(self,level):
		self.evaluateTerm()  																# get the first term into A

		while len(self.expr) > 0 and level < self.precedence[self.expr[0]]:  				# while the operator is at a lower precedence (if present)
			operator = self.expr.pop(0) 													# get the operator.
			self.push(self.a)
			self.evaluateRecursive(self.precedence[operator]) 								# call recursively with the level of the operator
			self.b = self.pop()  															# now ready for B <op> A
			self.calculate(operator) 														# do the calculation.
	#
	#		Do <a> := <b> operation <a>
	#
	def calculate(self,op):
		if op == "+":
			self.a = self.b + self.a
		elif op == "*":
			self.a = self.b * self.a
		elif op == "^":
			self.a = self.b ^ self.a
		else:
			assert "Bad operator "+op
	#
	#		Stack operations
	#
	def push(self,n):
		self.stack.append(n)
	def pop(self):
		return self.stack.pop()
	#
	#		Evaluate a term. More complex in reality.
	#
	def evaluateTerm(self):
		self.a = int(self.expr.pop(0))
	#
	#		Evaluate test. Get the python evaluator and this code to do the same thing.
	#
	def test(self,expr):
		r1 = eval(expr)
		r2 = self.evaluate(expr)
		if r1 != r2:
			print("Calculating {0} : Eval gives {1}, Expr gives {2}".format(expr,r1,r2))
#
#		Generate lots of random expressions and test them
#
ex = ExpressionEvaluator()
for i in range(0,1000*10):
	expr = ""
	for s in range(0,random.randint(0,10)*2+1):
		if s % 2 == 0:
			expr += chr(random.randint(48,57))
		else:
			expr += "+*^"[random.randint(0,2)]
	ex.test(expr)
