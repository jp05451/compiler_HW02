##################################################################
#
#	Makefile -- P Parser
#
##################################################################
scanner: y.tab.cpp lex.yy.cpp
	g++ -o scanner y.tab.cpp -ll

lex.yy.cpp: scanner.l
	lex -o lex.yy.cpp scanner.l

y.tab.cpp: parser.y
	yacc -o y.tab.cpp parser.y -d

clean:
	rm -f  lex.yy.cpp y.tab.cpp
