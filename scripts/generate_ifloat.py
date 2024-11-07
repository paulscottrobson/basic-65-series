# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		generate_ifloat.py
#		Purpose :	Output iFloats in binary format.
#		Date :		5th November 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re
from __ifloat_copy import *

print(";\n;\tThis file is automatically generated.\n;")									# Output the final mass include.
print("{0}:".format(sys.argv[1]))
for ns in sys.argv[2:]:
	n = IFloat(float(ns))
	s = "\t!byte ${0:02x},${1:02x},${2:02x},${3:02x},${4:02x},${5:02x} ; {6}".format(0x80 if n.isNegative else 0x00,
			n.exponent & 0xFF,n.mantissa & 0xFF,(n.mantissa >> 8) & 0xFF,(n.mantissa >> 16) & 0xFF,(n.mantissa >> 24) & 0xFF,ns)
	print(s)