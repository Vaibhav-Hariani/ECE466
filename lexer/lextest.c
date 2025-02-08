#include "tokens-manual.h"
#include "yylval.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern FILE *yyin;
extern int yylex();

int printn(const char *filename) {
	switch (yylval.n.type) {
		case TYPE_I:
			printf("%s\t%d\t%s\t%d\t%s\n",filename, line,
				"NUMBER\tINTEGER", (int) yylval.n.val.i, "INT");
			break;
		case TYPE_UI:
			printf("%s\t%d\t%s\t%u\t%s\n",filename, line,
				"NUMBER\tINTEGER", (unsigned int) yylval.n.val.i, "UNSIGNED,INT");
			break;
		case TYPE_LI:
			printf("%s\t%d\t%s\t%ld\t%s\n",filename, line,
				"NUMBER\tINTEGER", (long int) yylval.n.val.i, "LONG");
			break;
		case TYPE_ULI:
			printf("%s\t%d\t%s\t%lu\t%s\n",filename, line,
				"NUMBER\tINTEGER", (unsigned long int) yylval.n.val.i, "UNSIGNED,LONG");
			break;
		case TYPE_LLI:
			printf("%s\t%d\t%s\t%lld\t%s\n",filename, line,
				"NUMBER\tINTEGER", (long long int) yylval.n.val.i, "LONGLONG");
			break;
		case TYPE_ULLI:
			printf("%s\t%d\t%s\t%llu\t%s\n",filename, line,
				"NUMBER\tINTEGER", (unsigned long long int) yylval.n.val.i, "UNSIGNED,LONGLONG");
			break;
		case TYPE_FD:
			printf("%s\t%d\t%s\t%g\t%s\n",filename, line,
				"NUMBER\tREAL", (float) yylval.n.val.f, "FLOAT");
			break;
		case TYPE_D:
			printf("%s\t%d\t%s\t%lg\t%s\n",filename, line,
				"NUMBER\tREAL", (double) yylval.n.val.f, "DOUBLE");
			break;
		case TYPE_LD:
			printf("%s\t%d\t%s\t%Lg\t%s\n",filename, line,
				"NUMBER\tREAL", (long double) yylval.n.val.f, "LONGDOUBLE");
			break;
	}
}

char *token_name(int t) {

    if (t > TOKEOF && t < IDENT) {
        char *tok_name = calloc(1, sizeof(char));
        tok_name[0] = (char) t;
        return tok_name;
    }

    switch (t) {
        case TOKEOF:
            return strdup("TOKEOF");
	    case INDSEL:
            return strdup("PLUSPLUS");
	    case MINUSMINUS:
            return strdup("MINUSMINUS");
	    case SHL:
            return strdup("SHL");
	    case SHR:
            return strdup("SHR");
	    case LTEQ:
            return strdup("LTEQ");
	    case GTEQ:
            return strdup("GTEQ");
	    case EQEQ:
            return strdup("EQEQ");
	    case NOTEQ:
            return strdup("NOTEQ");
	    case LOGAND:
            return strdup("LOGAND");
	    case LOGOR:
            return strdup("LOGOR");
	    case ELLIPSIS:
            return strdup("ELLIPSIS");
	    case TIMESEQ:
            return strdup("TIMESEQ");
	    case DIVEQ:
            return strdup("DIVEQ");
	    case MODEQ:
            return strdup("MODEQ");
	    case PLUSEQ:
            return strdup("PLUSEQ");
	    case MINUSEQ:
            return strdup("MINUSEQ");
	    case SHLEQ:
            return strdup("SHLEQ");
	    case SHREQ:
            return strdup("SHREQ");
	    case ANDEQ:
            return strdup("ANDEQ");
	    case OREQ:
            return strdup("OREQ");
	    case XOREQ:
            return strdup("XOREQ");
	    case POUNDPOUND:
            return strdup("POUNDPOUND");
	    case AUTO:
            return strdup("AUTO");
	    case BREAK:
            return strdup("BREAK");
	    case CASE:
            return strdup("CASE");
	    case CHAR:
            return strdup("CHAR");
	    case CONST:
            return strdup("CONST");
	    case CONTINUE:
            return strdup("CONTINUE");
	    case DEFAULT:
            return strdup("DEFAULT");
	    case DO:
            return strdup("DO");
	    case DOUBLE:
            return strdup("DOUBLE");
	    case ELSE:
            return strdup("ELSE");
	    case ENUM:
            return strdup("ENUM");
	    case EXTERN:
            return strdup("EXTERN");
	    case FLOAT:
            return strdup("FLOAT");
	    case FOR:
            return strdup("FOR");
	    case GOTO:
            return strdup("GOTO");
	    case IF:
            return strdup("IF");
	    case INLINE:
            return strdup("INLINE");
	    case INT:
            return strdup("INT");
	    case LONG:
            return strdup("LONG");
	    case REGISTER:
            return strdup("REGISTER");
	    case RESTRICT:
            return strdup("RESTRICT");
	    case RETURN:
            return strdup("RETURN");
	    case SHORT:
            return strdup("SHORT");
	    case SIGNED:
            return strdup("SIGNED");
	    case SIZEOF:
            return strdup("SIZEOF");
	    case STATIC:
            return strdup("STATIC");
	    case STRUCT:
            return strdup("STRUCT");
	    case SWITCH:
            return strdup("SWITCH");
	    case TYPEDEF:
            return strdup("TYPEDEF");
	    case UNION:
            return strdup("UNION");
	    case UNSIGNED:
            return strdup("UNSIGNED");
	    case VOID:
            return strdup("VOID");
	    case VOLATILE:
            return strdup("VOLATILE");
	    case WHILE:
            return strdup("WHILE");
	    case _BOOL:
            return strdup("_BOOL");
	    case _COMPLEX:
            return strdup("_COMPLEX");
	    case _IMAGINARY:
            return strdup("_IMAGINARY");
    }
}

int main(int argc, char const *argv[]) {
	int t;
    char *tok_name;
	yyin = stdin;

	while (t = yylex()) {
		switch (t) {
			case IDENT:
				printf("%s\t%d\t%s\t%s\n", filename, line, "IDENT", yylval.s);
				break;
            case CHARLIT:
                printf("%s\t%d\t%s\t%s\n", filename, line, "CHARLIT", yylval.s);
                break;
            case STRING:
                printf("%s\t%d\t%s\t%s\n", filename, line, "STRING", yylval.s);
                break;
			case NUMBER:
				printn(filename);
				break;
			default:
                tok_name = token_name(t);
                printf("%s\t%d\t%s\n", filename, line, tok_name);
                free(tok_name);
                break;
		}
	}
	
    return 0;
}