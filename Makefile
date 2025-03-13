
CFLAGS = -Wall -Wno-abi -I ./lexer -I ./parser

all: parser

flex: lexer/lex.l
	cd lexer && flex lex.l

bison: parser/ast_nodes.c parser/ast_nodes.h parser/parser.y parser/parse_output.h
	cd parser && bison -d parser.y

bison_debug: parser/ast_nodes.c parser/ast_nodes.h parser/parser.y
	cd parser && bison --debug -d parser.y 

parser: flex bison
	gcc -o parser/parser.out $(CFLAGS) parser/parser.tab.c lexer/lex.yy.c parser/ast_nodes.c parser/parse_output.c

debug_parser: flex bison_debug
	gcc -o parser/parser_debug.out $(CFLAGS) -g parser/parser.tab.c lexer/lex.yy.c parser/ast_nodes.c parser/parse_output.c

clean:
	rm -rf *.h.gch parser/*.out lexer/lex.yy.c parser/parser.tab.* 
