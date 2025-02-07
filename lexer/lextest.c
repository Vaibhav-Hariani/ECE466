#include "tokens-manual.h"
#include "yylval.h"
#include <stdio.h>

extern FILE *yyin;
extern int yylex();

int printn(const char *filename) {
	switch (yylval.n.type) {
		case TYPE_I:
			printf("%s\t%d\t%s\t%d\t%s\n",filename, line,
				"NUMBER", (int) yylval.n.val.i, "INT");
			break;
		case TYPE_UI:
			printf("%s\t%d\t%s\t%u\t%s\n",filename, line,
				"NUMBER", (unsigned int) yylval.n.val.i, "UNSIGNED,INT");
			break;
		case TYPE_LI:
			printf("%s\t%d\t%s\t%ld\t%s\n",filename, line,
				"NUMBER", (long int) yylval.n.val.i, "LONG");
			break;
		case TYPE_ULI:
			printf("%s\t%d\t%s\t%lu\t%s\n",filename, line,
				"NUMBER", (unsigned long int) yylval.n.val.i, "UNSIGNED,LONG");
			break;
		case TYPE_LLI:
			printf("%s\t%d\t%s\t%lld\t%s\n",filename, line,
				"NUMBER", (long long int) yylval.n.val.i, "LONGLONG");
			break;
		case TYPE_ULLI:
			printf("%s\t%d\t%s\t%llu\t%s\n",filename, line,
				"NUMBER", (unsigned long long int) yylval.n.val.i, "UNSIGNED,LONGLONG");
			break;
		case TYPE_FD:
			printf("%s\t%d\t%s\t%f\t%s\n",filename, line,
				"NUMBER", (float) yylval.n.val.f, "FLOAT");
			break;
		case TYPE_D:
			printf("%s\t%d\t%s\t%lf\t%s\n",filename, line,
				"NUMBER", (double) yylval.n.val.f, "DOUBLE");
			break;
		case TYPE_LD:
			printf("%s\t%d\t%s\t%Lf\t%s\n",filename, line,
				"NUMBER", (long double) yylval.n.val.f, "LONGDOUBLE");
			break;
	}
}

int main(int argc, char const *argv[]) {
	int t;
	yyin = stdin;

	while (t = yylex()) {
		switch (t) {
			case IDENT:
				printf("%s\t%d\t%s\t%s\n", argv[1], line, "STRING", yylval.s);
				break;
			case NUMBER:
				printn(argv[1]);
				break;

			/* etc etc */
			default:
				break;
		}
	}
	
    return 0;
}