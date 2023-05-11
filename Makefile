##################################################################
#
#	Makefile -- P Parser
#
##################################################################

p: lex.yy.o y.tab.o symbols.o parser.o
	gcc -o p lex.yy.o y.tab.o symbols.o parser.o -ll

lex.yy.o: lex.yy.c symbolTable.hpp y.tab.h
	gcc -c -g lex.yy.c

y.tab.o: y.tab.c symbolTable.hpp y.tab.h
	gcc -c -g y.tab.c

lex.yy.c: scanner.l symbolTable.hpp y.tab.h
	lex scanner.l

y.tab.c: parser.y symbolTable.hpp
	yacc -v parser.y

# symbols.o: symbols.c symbolTable.hpp
# 	gcc -c -g symbols.c

parser.o: parser.c
	gcc -c -g parser.c
clean:
	rm -f p *.o lex.yy.c y.tab.c
