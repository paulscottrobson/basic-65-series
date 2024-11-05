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
ACME_COMMON = acme -Wtype-mismatch -l $(BINDIR)build.lbl -r $(BINDIR)build.lst -f plain
ACME6502 = $(ACME_COMMON) -DTARGET=16 -DCPU=6502 --cpu 65C02  -o $(OBJECT) __build.tmp
#
#		Emulators and other external tools
#
X16EMU = /aux/builds/x16-emulator/x16emu
X16_6502 = $(X16EMU) -debug -scale 2 
#
#		Uncommenting .SILENT will shut the whole build up.
#
ifndef VERBOSE
#.SILENT:
endif
#
#		Default Rules
#
asm65: prelim builder
	$(ACME6502)

run65: asm65
	$(X16_6502) -prg $(OBJECT) -run

builder: 
	$(PYTHON) $(SCRIPTDIR)builder.py @$(ROOTDIR)modules $(MODULES) >__build.tmp