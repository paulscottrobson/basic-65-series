# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		show_string.py
#		Purpose :	Output string length prefixed.
#		Date :		12th November 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re

mem = [x for x in open(sys.argv[1],"rb").read(-1)]
for s in sys.argv[2:]:
	addr = eval(s)
	print("Length:{0} \"{1}\"".format(mem[addr],"".join([chr(mem[addr+i+1]) for i in range(0,mem[addr])])))