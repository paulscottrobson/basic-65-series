# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		build.make
#		Purpose :	Common make building stuff
#		Date :		8th November 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

asm8: prelim builder
	echo "Assembling 65C02 code"
	$(ACME6502)

run8: asm8
	rm -f dump*.bin
	$(X16EMU) -c02 -prg $(OBJECT) -run

builder:
	echo "Building module script" 
	$(PYTHON) $(SCRIPTDIR)builder.py @$(ROOTDIR)modules $(MODULES) >__build.tmp