# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		keywords.py
#		Purpose :	Keyword classes
#		Date :		14th November 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

# *******************************************************************************************
#
#									Keywords data class
#
# *******************************************************************************************

class Keywords(object):
	#
	#		Get the structure keywords (these are $80-$8F)
	#
	def getStructures(self):
		return  self.process("""
			WHILE:+ WEND:- REPEAT:+ UNTIL:- FOR:+ NEXT:- CASE:+ ENDCASE:- DO:+ LOOP:- PROC:+ ENDPROC:-
			IF:+ THEN:- ENDIF:-
			""")
	#
	#		Get the binary operator keywords (these are $90-$0F)
	#
	def getBinaryOperators(self):
		return  self.process("""
			AND:1 OR:1 XOR:1 
			>=:2 <=:2 <>:2 =:2 >:2 <:2
			+:3 -:3
			*:4 /:4 <<:4 >>:4
			^:5
		""")
	#
	#		Get the control & shift keywords (these are $A0-$A5)
	#
	def getControlKeywords(self):
		return  self.process("""
			[EOL] [SH1] [SH2] [SH3] [STR] [DEC]
		""")
	#
	#		Get the unary operators. Yes, ( is a unary operator 
	#
	def getUnaryKeywords(self):
		return  self.process("""
			(
			PEEK( FN( NOT SGN( INT( ABS( RND( 
			LEN( STR$( VAL( ASC( CHR$( LEFT$( RIGHT$( MID$( PI
			DEEK( RANDOM( TIME( TRUE FALSE MAX( MIN(
		""")
	#
	#		Get the base set of keywords
	#
	def getBaseKeywords(self):
		return  self.process("""
			: ; , ) #
			WHEN EXIT TO STEP REM POKE PRINT 
			DOKE LOCAL ELSE 
		""")
	#
	#		Get the Shift-1 Keywords (less common, or slow)
	#
	def getShift1Keywords(self):
		return  self.process("""
			END READ DATA INPUT DIM LET GOTO RUN STOP 
			RESTORE GOSUB RETURN WAIT LOAD SAVE VERIFY ON DEF 
			CONT LIST CLR CMD SYS OPEN CLOSE GET NEW GO 
			ASSERT 
		""")
	#
	#		Get the Shift-2 Unary Keywords (less common or slow)
	#
	def getShift2Keywords(self):
		return  self.process("""
			SQR( USR( FRE( POS( SQR( TAB( SPC(
			LOG( EXP( COS( SIN( TAN( ATN(
		""")
	#
	#		Postprocess a keyword string
	#
	def process(self,s):
		return s.upper().strip().split()

print(Keywords().getBaseKeywords())