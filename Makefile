
CFLAGS = -Wall -I./lexer -I ./parser
flex: lexer/lex.l
	cd lexer && flex lex.l

bison: parser/ast_nodes.c parser/ast_nodes.h parser/parser.y
	cd parser && bison -d parser.y

bison_debug: parser/ast_nodes.c parser/ast_nodes.h parser/parser.y
	cd parser && bison --debug -d parser.y 

parser: flex bison
	gcc  $(CFLAGS) parser/parser.tab.c lexer/lex.yy.c parser/ast_nodes.c 

debug_parser: flex bison_debug
	gcc -o parser_debug.out $(CFLAGS) -g parser/parser.tab.c lexer/lex.yy.c parser/ast_nodes.c