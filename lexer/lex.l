%{
#include "tokens-manual.h"
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include <errno.h>

enum types {
    TYPE_I=0,
    TYPE_UI=1,
    TYPE_LI=2,
    TYPE_ULI=3,
    TYPE_LLI=4,
    TYPE_ULLI=5,
    TYPE_FD=6,
    TYPE_D=7,
    TYPE_LD=8
}

typedef union {
	long long int i;
	long double f;
} NumberValue

typedef struct {
	NumberValue val;
	char type;
} TypedNumber

typedef union {
	char *s;
	TypedNumber n;
} YYSTYPE;

extern YYSTYPE yylval;
extern int line;
%}

id			[A-Za-z_][A-Za-z0-9_]*
charlit		\'.\'
string		\".+\"
octint		[\+-]?0[0-7]*([Uu]?[L|LL|l|ll]?)|([L|LL|l|ll]?[Uu]?)
decint		[\+-]?[1-9][0-9]*([Uu]?[L|LL|l|ll]?)|([L|LL|l|ll]?[Uu]?)
hexint		[\+-]?0[Xx][0-9A-Fa-f]+([Uu]?[L|LL|l|ll]?)|([L|LL|l|ll]?[Uu]?)
decflt		[\+-]?(([0-9]+\.[0-9]*)|([0-9]*\.[0-9]+))([Ee][\+-]?[0-9]+)?[FLfl]?
hexflt		[\+-]?0[Xx](([0-9A-Fa-f]+\.[0-9A-Fa-f]*)|([0-9A-Fa-f]*\.[0-9A-Fa-f]+))([Pp][\+-]?[0-9]+)?[FLfl]?
newline		\n
ws			[ \t\r]+

%%
;				{/* INSERT SINGLE-CHARACTER TOKENS */}
"->"			{return(INDSEL);}
"++"			{return(PLUSPLUS);}
"--"			{return(MINUSMINUS);}
"<<"			{return(SHL);}
">>"			{return(SHR);}
"<="			{return(LTEQ);}
">="			{return(GTEQ);}
"=="			{return(EQEQ);}
"!="			{return(NOTEQ);}
"&&"			{return(LOGAND);}
"||"			{return(LOGOR);}
"..."			{return(ELLIPSIS);}
"*="			{return(TIMESEQ);}
"/="			{return(DIVEQ);}
"%="			{return(MODEQ);}
"+="			{return(PLUSEQ);}
"-="			{return(MINUSEQ);}
"<<="			{return(SHLEQ);}
">>="			{return(SHREQ);}
"&="			{return(ANDEQ);}
"|="			{return(OREQ);}
"^="			{return(XOREQ);}
"auto"			{return(AUTO);}
"break"			{return(BREAK);}
"case"			{return(CASE);}
"char"			{return(CHAR);}
"const"			{return(CONST);}
"continue"		{return(CONTINUE);}
"default"		{return(DEFAULT);}
"do"			{return(DO);}
"double"		{return(DOUBLE);}
"else"			{return(ELSE);}
"enum"			{return(ENUM);}
"extern"		{return(EXTERN);}
"float"			{return(FLOAT);}
"for"			{return(FOR);}
"goto"			{return(GOTO);}
"if"			{return(IF);}
"inline"		{return(INLINE);}
"int"			{return(INT);}
"long"			{return(LONG);}
"register"		{return(REGISTER);}
"restrict"		{return(RESTRICT);}
"return"		{return(RETURN);}
"short"			{return(SHORT);}
"signed"		{return(SIGNED);}
"sizeof"		{return(SIZEOF);}
"static"		{return(STATIC);}
"struct"		{return(STRUCT);}
"switch"		{return(SWITCH);}
"typedef"		{return(TYPEDEF);}
"union"			{return(UNION);}
"unsigned"		{return(UNSIGNED);}
"void"			{return(VOID);}
"volatile"		{return(VOLATILE);}
"while"			{return(WHILE);}
"_Bool"			{return(_BOOL);}
"_Complex"		{return(_COMPLEX);}
"_Imaginary"	{return(_IMAGINARY);}
{id}			{yylval.s=strdup(yytext);	return(IDENT);}
{charlit}		{yylval.s=charlit_val();	return(CHARLIT);}
{string}		{yylval.s=string_val();		return(STRING);}
{octint}		{yylval.n=number_val('o');	return(NUMBER);}
{decint}		{yylval.n=number_val('i');	return(NUMBER);}
{hexint}		{yylval.n=number_val('h');	return(NUMBER);}
{decflt}		{yylval.n=number_val('I');	return(NUMBER);}
{hexflt}		{yylval.n=number_val('H');	return(NUMBER);}
{newline}		{line++;}
{ws}			{/*empty*/}

%%

/*	handle char literals similarly
	to flex start conditions  */
char *charlit_val() {
	/* process here */
	return strdup(yytext);
}

/*	handle string literals similarly
	to flex start conditions  */
char *string_val() {
	/* process here */
	return strdup(yytext);
}

/* determine the type of number,
   store in TypedNumber number */
void num_val(char type) {
	TypedNumber tn;

	if (type == 'o' || type == 'i' || type == 'h') { /* integer */
		tn.type = TYPE_I;
		for (int idx = yyleng-1; idx >= yyleng-4 && idx >= 0; idx--) {
			if (yyltext[idx] == 'U' || yyltext[idx] == 'u') {
				tn.type++;
			} else if (yyltext[idx] == 'L' || yyltext[idx] == 'l') {
				tn.type += 2;
			} else {
				break;
			}
		}

		errno = 0;
		tn.val.i = (yyltext[0] == '-')? strtoll(yyltext, NULL, 0) : strtoull(yyltext, NULL, 0);
		unsigned long long int uval = (unsigned long long int) tn.val.i;
		
		if (errno == ERANGE) {/* ERROR */}
		if (tn.type % 2 == 1 && yyltext[0] == '-') {/* ERROR */}

		/*	below we try to determine the correct type
			if not adequately specified with a suffix
		
			when a positive int's type needs to grow,
			we make it longer before we make it unsigned
			e.g. int 3000000000 becomes long int rather than unsigned int
			this was an arbitrary decision and theoretically more costly,
			but avoids erroneous unsigning.  */
		
		if (tn.type == TYPE_I && (
			(yyltext[0] == '+' && uval > INT_MAX) ||
			(yyltext[0] == '-' && tn.val.i < INT_MIN) )) {
			tn.type = TYPE_LI;
		}

		if (tn.type == TYPE_LI && (
			(yyltext[0] == '+' && uval > LONG_MAX) ||
			(yyltext[0] == '-' && tn.val.i < LONG_MIN) )) {
			tn.type = TYPE_LLI;
		}

		if (tn.type == TYPE_LLI &&
			(yyltext[0] == '+' && uval > LLONG_MAX)) {
			tn.type = TYPE_ULLI;
		}
	}	

	else { /* floating */
		tn.type = TYPE_D;
		tn.type += (yytext[yyleng-1] == 'L' || yytext[yyleng-1] == 'l');
		tn.type -= (yytext[yyleng-1] == 'F' || yytext[yyleng-1] == 'f');

		errno = 0;
		tn.val.f = strtold(yyltext, NULL, 0);

		if (errno == ERANGE) {/* ERROR */}

		/*	the above method of inferring necessary type adjustments
			does not apply here.  */
	}

	return tn;
}
