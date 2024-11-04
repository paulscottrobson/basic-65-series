# Outline design

The code is released under the MIT license.

## Target machines

Primarily

- Mega 65 (45GS02)
- Commander X16 (65C02 current design) and compatibles
- Commander X16 (65C816 variant) and compatibles
- any other person that wants it.

## Interpreter

A modernised BASIC largely compatible with Microsoft BASIC. Added structures, long variable names, named procedures. Initially no parameters. Allow simple local variables. GOTO and GOSUB still work but are discouraged and *no* RENUMBER is available.  

Using RETURN and NEXT to stack unwind, an awful programming practice which should have died out in the 1980s, will be discouraged but may be an option.

Likely no inline assembler partly due to having 3 different target processors.  I found in practice I didn't use it. 

### Additional functionality

Both the main target machines have their own extensions, so a system will be needed to add arbitrary commands and functions on a per system basis, which will be the same system as I'm likely to use in the rest of the interpreter, a scanning / automatic system.

## Processor

Processors of the type 65C02 and better are supported, this includes the 65816 and 4502 processors, including the extensions of the Mega65.  Rockwell and any other non common extensions will not be used, except perhaps in system specific optimisations.

The primary variations will be in having 16 (65816) and 32 (4510) bit options when doing things like adding mantissae which will require far more instructions on a 6502 than a 65816 or 4502 (with Mega65 extensions). Additionally, the extended opcodes and addressing modes may be used for incrementing and decrementing pointers, and maybe some other things.

Most of the code will run in 8 bit mode.  This will be done using macros. For the 4502 and any other active-Z variants, it will assume Z = 0 throughout.

It will not run on the original 65C02

## Memory

Memory is segmented, this is designed for a paging system. Memory is used as follows

- Main memory : used for program code and temporary variables. . Strings are allocated from the end of code up, arrays and shared memory from the top down.
- Variable Page : used for variable references (upwards).  Memory from the top down can be used to load prebuilt assembler, and SYS should allow for this (switching this page in before call)
- Code Page(s) : contain tokenised BASIC in a typical structure, multiple pages are allowed.

In most of the considered systems paging is 8k which fits quite well. It does have a limitation on array memory if people are allocating really big arrays for some reason.

This design allows the implementation of the STOS style system whereby multiple instances of BASIC programmes can run on the same processor. So for example a sprite editor could run in one BASIC instance and you could switch to and from it while developing. However, this does not support task switching in mid program run.

These do not have to exist in paged memory, it should run perfectly well in a flat memory map, with the variant that specific sizes are allocated to each area. In most BASIC interpreters this is done on the fly to maximise memory use. 

### Zero Page

Zero page usage will be minimised, though there will be an option to put the FP Registers into zero page. The requirement will probably be < 16 bytes - code pointer, some temporary registers for memory access, which should not be an issue for any machine.

## Mathematics

The BASIC will use the iFloat library (see reference), which will give significant speed increases when dealing with integers. SIN COS TAN ATAN LOG EXP will not be supported unless people really complain.  The offset exponent will remain. 

Most people write games or tools, nobody is going to do scientific mathematics using this. If you want to do something like Asteroids movement a look up table is way better. 

## Import

Direct import is not possible ; this is down to the TOTAL problem - is it the token TO followed by TAL text, an identifier TOTAL or a variable TO with the TAL discarded.  Syntactic chaos.

So MS BASIC will have to be converted to text and imported. Identifiers are a sequence of alphanumerics (beginning with an alpha) ending in $ or % (optionally) followed by a ( (optionally)

For consistency this will insert quotes in DATA statements, a syntactic mistake by the creators of Dartmouth BASIC I suspect. It will also handle REM statements, but may well hide the quotes and put them in automagically in the tokeniser.

## Editor

A single line per LOC (e.g. Nano horizontal scrolling) along the basis of the one implemented for the Neo6502 with the same generalisation options.

## Notes

