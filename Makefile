# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		Makefile
#		Purpose :	Make file, changes depending on what working on.
#		Date :		8th November 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

#include build_env/common.make

MODULE = modules/testing/float.develop

all: 
	make -C $(MODULE) run8 show