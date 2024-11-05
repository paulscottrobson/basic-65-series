## Sources

Sources are contained in modules, which can be any subdirectory under the 'modules' subdirectory in the source tree. This can be a directory with a whole series of subdirectories or a specific subdirectory.

The source constructor builds a file which includes as source all the relevant subfiles.  The input is a list of included subdirectories, so maths/unary as a parameter would include all the sources under modules/maths/unary.

Sources of type .asm  and .inc are added to the list of sources supported in alphabetical order with all the underscores removed. When output, .inc files come first (these do not generate code) followed by .asm files in order of the root file name.

Filenames beginning with 0n where n is 0-9 are added first, and are reserved for system things. 1n is reserved for processor specific initialise files. 2n is reserved for build specific files that should come first (e.g. startup code) in a specific build.

Files with an underscore prefix are assumed to be temporary/generated files and are included, but should be excluded from the github using .gitignore

In the modules subdirectory where the sources live, the module "common" contains all the setup for things like zero page usage and similar (which will be mostly 0n type files)

The build sets -DCPU=processor (6502,65816,4502) for the three main processor types which can be used to set system specific code where needed that is not done via macros, and -DTARGET=target (16 for Commander X16, 65 for Mega65)