#include "tokens-manual.h"
#include "yylval.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

extern FILE *yyin;
extern int yylex();

void printn() {
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

void printli(char *li, int size) {
	int i;

	for (i = 0; i < size; i++) {
		// everybody say 'thank you C99 w.d. 5.2.2, 7.4.1.8'
		if (isprint(li[i])) {
			if (li[i] == '\'' || li[i] == '\"' || li[i] == '\\') {
				printf("\\%c", li[i]);
			} else {
				printf("%c", li[i]);
			}
			continue;
		}

		switch(li[i]) {
			case '\0':
				printf("\\0");
				break;
			case '\a':
				printf("\\a");
				break;
			case '\b':
				printf("\\b");
				break;
			case '\f':
				printf("\\f");
				break;
			case '\n':
				printf("\\n");
				break;
			case '\r':
				printf("\\r");
				break;
			case '\t':
				printf("\\t");
				break;
			case '\v':
				printf("\\v");
				break;
			default: /* octal esc sequence */
				printf("\\%03o", (unsigned char) li[i]);
				break;
		}
	}

	printf("\n");
	return;
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
            return strdup("INDSEL");
        case PLUSPLUS:
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
	char *cbuf, *tok_name;
	
	yyin = stdin;
	cbuf = (char *) calloc(1, sizeof(char));
	while (t = yylex()) {
		switch (t) {
			case IDENT:
				printf("%s\t%d\t%s\t%s\n", filename, line, "IDENT", yylval.i);
				break;
            case CHARLIT:
                printf("%s\t%d\t%s\t", filename, line, "CHARLIT");
				cbuf[0] = yylval.c;
				printli(cbuf, 1);
                break;
            case STRING:
				printf("%s\t%d\t%s\t", filename, line, "STRING");
				printli(yylval.s.li, yylval.s.size);
                break;
			case NUMBER:
				printn();
				break;
			default:
                tok_name = token_name(t);
                printf("%s\t%d\t%s\t\n", filename, line, tok_name);
                free(tok_name);
                break;
		}
	}
	
	free(cbuf);
    return 0;
}