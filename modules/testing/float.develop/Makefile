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
include $(BUILDDIR)build.make

OBJECT = $(BINDIR)test.prg
MODULES = common ifloat polynomial:active testing:float.develop

all: asm8

prelim:
	cp $(ROOTDIR)documents/ifloat-reference/ifloat.py $(SCRIPTDIR)/__ifloat_copy.py
	make -C ../../polynomial
	$(PYTHON) $(SCRIPTDIR)generate_ifloat.py test_float 3.14159 >_testdata.asm

show:
	$(PYTHON) $(SCRIPTDIR)show_ifloat.py dump.bin 0x22
	$(PYTHON) $(SCRIPTDIR)show_ifloat.py dump.bin 0x28
	$(PYTHON) $(SCRIPTDIR)show_string.py dump.bin 0x400
