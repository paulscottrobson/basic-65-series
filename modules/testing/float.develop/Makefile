# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		Makefile
#		Purpose :	Make test file
#		Date :		5th November 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

include ../../../build_env/common.make

OBJECT = $(BINDIR)test.prg
MODULES = common ifloat testing:float.develop

all: asm8

prelim:
	cp $(ROOTDIR)documents/ifloat-reference/ifloat.py $(SCRIPTDIR)/__ifloat_copy.py
	$(PYTHON) $(SCRIPTDIR)generate_ifloat.py test_float 123000 456 >_testdata.asm

show:
	$(PYTHON) $(SCRIPTDIR)show_ifloat.py dump.bin 22
