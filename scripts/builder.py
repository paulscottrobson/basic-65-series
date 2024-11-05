# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		builder.py
#		Purpose :	Construct assembler scripts
#		Date :		5th November 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re

currentRoot = None  																	# Current directory to get module from
incFiles = []  																			# include files
asmFiles = []  																			# assembly files

for c in sys.argv[1:]:  																# Scan command line
	if c.startswith("@"):  																# New module ?
		currentRoot = c[1:]
		assert os.path.isdir(currentRoot),"Unknown directory "+currentRoot
	else:
		assert currentRoot is not None,"No root defined"  								# Search for module in current
		directory = currentRoot+os.sep+c.replace(":",os.sep)
		assert os.path.isdir(directory),"Unknown module in directory "+directory
		for root,dirs,files in os.walk(directory):  									# Scan
			for f in files:
				if f.endswith(".inc") or f.endswith(".asm"):  							# known type
					fileSpec = { "full":root+os.sep+f,"key":f.replace("_","").lower() } # create Records
					if f.endswith(".inc"):  											# add to the list.
						incFiles.append(fileSpec)
					else:
						asmFiles.append(fileSpec)

incFiles.sort(key = lambda x:x["key"])  												# sort lists by key
asmFiles.sort(key = lambda x:x["key"])

for f in incFiles+asmFiles:
	print("\t!source \"{0}\"".format(f["full"]))