PYTHON = python3
#
#		Directories
#
ROOTDIR =  $(dir $(realpath $(lastword $(MAKEFILE_LIST))))../
BINDIR = $(ROOTDIR)bin/
SCRIPTDIR = $(ROOTDIR)scripts/
#
#		Assembler directives
#
ACME_COMMON = acme -Wtype-mismatch -l $(BINDIR)build.lbl -r $(BINDIR)build.lst -f cbm
ACME6502 = $(ACME_COMMON) -DTARGET=16 -DCPU=6502 --cpu 65C02  -o $(OBJECT) __build.tmp
#
#		Emulators and other external tools
#
X16EMU = /aux/builds/x16-emulator/x16emu -debug -scale 2 -dump R 
#
#		Uncommenting .SILENT will shut the whole build up.
#
ifndef VERBOSE
.SILENT:
endif
#
#		Default Rules
#
asm8: prelim builder
	echo "Assembling 65C02 code"
	$(ACME6502)

run8: asm8
	rm -f dump*.bin
	$(X16EMU) -c02 -prg $(OBJECT) -run

builder:
	echo "Building module script" 
	$(PYTHON) $(SCRIPTDIR)builder.py @$(ROOTDIR)modules $(MODULES) >__build.tmp