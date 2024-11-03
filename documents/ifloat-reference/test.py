# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		test.py
#		Purpose :	Test all
#		Date :		24th October 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,math,random
from ifloat import *
from mathop import *
from add import *
from multiply import *
from divide import *
from intdiv import *
from integer import *
from fractional import *

random.seed(42)
binList = [ AddOperation(),DivideOperation(),MultiplyOperation() ]
unaList = [ IntegerOperation(),FractionalOperation() ]
intOp = IntegerDivideOperation()

for i in range(0,1000*1000):
	for b in binList:
		b.test()
	for u in unaList:
		u.test()
	intOp.test(True)