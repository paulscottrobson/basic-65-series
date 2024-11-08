# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		common.make
#		Purpose :	Common make
#		Date :		5th November 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

PYTHON = python3
#
#		Directories
#
ROOTDIR =  $(dir $(realpath $(lastword $(MAKEFILE_LIST))))../
BINDIR = $(ROOTDIR)bin/
BUILDDIR = $(ROOTDIR)/build_env/
SCRIPTDIR = $(ROOTDIR)scripts/
#
#		Assembler directives
#
ACME_COMMON = acme -l $(BINDIR)build.lbl -r $(BINDIR)build.lst -f cbm
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
