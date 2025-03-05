flex: lexer/lex.l
	flex lexer/lex.l

bison: parser/ast_nodes.c parser/ast_nodes.h parser/parser.y
	bison -d parser/parser.y

parser: flex bison
	gcc parser/parser.tab.c parser/parser.tab.h lexer/lex.yy.c lexer/yylval.h parser/ast_nodes.c parser/ast_nodes.h
	