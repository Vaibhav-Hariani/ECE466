%option noyywrap
%{
#include "tokens-manual.h"
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include <errno.h>

enum types {
    TYPE_I=0,
    TYPE_UI,
    TYPE_LI,
    TYPE_ULI,
    TYPE_LLI,
    TYPE_ULLI,
    TYPE_FD,
    TYPE_D,
    TYPE_LD
};

typedef union {
	long long int i;
	long double f;
} NumberValue;

typedef struct {
	NumberValue val;
	char type;
} TypedNumber;

typedef union {
	char *s;
	char c;
	TypedNumber n;
} YYSTYPE;

YYSTYPE yylval;
int line;

char *char_parse();
char charlit_val();
char *string_val();
TypedNumber number_val(char type);

%}

id		[A-Za-z_][A-Za-z0-9_]*

octint		[\+-]?0[0-7]*([Uu]?[L|LL|l|ll]?)|([L|LL|l|ll]?[Uu]?)
decint		[\+-]?[1-9][0-9]*([Uu]?[L|LL|l|ll]?)|([L|LL|l|ll]?[Uu]?)
hexint		[\+-]?0[Xx][0-9A-Fa-f]+([Uu]?[L|LL|l|ll]?)|([L|LL|l|ll]?[Uu]?)
decflt		[\+-]?(([0-9]+\.[0-9]*)|([0-9]*\.[0-9]+))([Ee][\+-]?[0-9]+)?[FLfl]?
hexflt		[\+-]?0[Xx](([0-9A-Fa-f]+\.[0-9A-Fa-f]*)|([0-9A-Fa-f]*\.[0-9A-Fa-f]+))([Pp][\+-]?[0-9]+)?[FLfl]?

/* from here until str_lit defines: */
/*  char_const (ref C99 w.d. 6.4.4.4) */
/*  str_lit (ref C99 w.d. 6.5) */
simple_esc	"\\"[\'\"\?\\abfnrtv]
oct_esc		"\\"[0-7]?[0-7]?[0-7]?
hex_esc		"\\x"[0-9A-Fa-f]+
hex_quad	[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]
uni_char	"\\"(u|(U{hex_quad})){hex_quad}
esc_seq		{simple_esc}|{oct_esc}|{hex_esc}|{uni_char}

c_char		.&[^\'\\\n]|{esc_seq}
char_const	L?\'{c_char}+\'

s_char		(.&[^\"\\\n])|{esc_seq}
str_lit		L?\"{s_char}*\"

newline		\n
ws		[ \t\r]+

%%
";"				{return(';');}

"+"				{return('+');}
"-"				{return('-');}
"*"				{return('*');}
"/"				{return('/');}
"%"				{return('%');}
">"				{return('>');}
"<"				{return('<');}
"="				{return('=');}

","				{return(',');}

":"				{return(':');}
"?"				{return('?');}
"&"				{return('&');}
"|"				{return('|');}
"!"				{return('!');}
"^"				{return('^');}
"~"				{return('~');}

"("				{return('(');}
")"				{return(')');}
"["				{return('[');}
"]"				{return(']');}
"{"				{return('{');}
"}"				{return('}');}

"<:"			{return('[');}
":>"			{return(']');}
"<%"			{return('{');}
"%>"			{return('}');}
"%:"			{return('#');}
"%:%:"			{return(POUNDPOUND);}

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
"##"			{return(POUNDPOUND);}

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
"_Imaginary"		{return(_IMAGINARY);}

{id}			{yylval.s=strdup(yytext);	return(IDENT);}
{char_const}		{yylval.c=charlit_val();	return(CHARLIT);}
{str_lit}		{yylval.s=string_val();		return(STRING);}
{octint}		{yylval.n=number_val('o');	return(NUMBER);}
{decint}		{yylval.n=number_val('i');	return(NUMBER);}
{hexint}		{yylval.n=number_val('h');	return(NUMBER);}
{decflt}		{yylval.n=number_val('I');	return(NUMBER);}
{hexflt}		{yylval.n=number_val('H');	return(NUMBER);}
{newline}		{line++;}
{ws}			{/*empty*/}

%%

char *char_parse() {
	int i, buf_idx;
	char *buf;

	buf_idx = 0;

	/* not implementing wide chars */
	buf = (char *) calloc(yyleng-2, sizeof(char));

	/* exclude '' and "" */
	for (i = 1; i < yyleng-1; i++) {
		if (yytext[i] == '\\') {
			/* esc seq start*/
			switch (yytext[++i]) { /* first char of esc seq */
				case '0': case 'a': case 'b':
				case 'f': case 'n': case 'r':
				case 't': case 'v':
					buf[buf_idx++] = '\\';
					buf[buf_idx++] = yytext[i];
					break;
				case '\'': case '\"':
				case '\?': case '\\':
					buf[buf_idx++] = yytext[i];
					break;
				case 'x':
					/* INCOMPLETE: handle hex esc seq */
					break;
				case 'u': case 'U':
					/* optional, unimplemented */
					break;
				default:
					/* INCOMPLETE: handle non-zero octal esc seq */
					break;
			}
		} else { /* not in esc seq */
			buf[buf_idx++] = yytext[i];
		}
	}

	return buf;
}

char charlit_val() {
	/* process here using char_parse */
	return yytext[1];
}

char *string_val() {
	/* process here using char_parse*/
	return strdup(yytext);
}

/* determine the type of number,
   store in TypedNumber number */
TypedNumber number_val(char type) {
	TypedNumber tn;

	if (type == 'o' || type == 'i' || type == 'h') { /* integer */
		tn.type = TYPE_I;
		for (int idx = yyleng-1; idx >= yyleng-4 && idx >= 0; idx--) {
			if (yytext[idx] == 'U' || yytext[idx] == 'u') {
				tn.type++;
			} else if (yytext[idx] == 'L' || yytext[idx] == 'l') {
				tn.type += 2;
			} else {
				break;
			}
		}

		errno = 0;
		tn.val.i = (yytext[0] == '-')? strtoll(yytext, NULL, 0) : strtoull(yytext, NULL, 0);
		unsigned long long int uval = (unsigned long long int) tn.val.i;
		
		if (errno == ERANGE) {/* ERROR */}
		if (tn.type % 2 == 1 && yytext[0] == '-') {/* ERROR */}

		/*	below we try to determine the correct type
			if not adequately specified with a suffix
		
			when a positive int's type needs to grow,
			wINDSELe make it longer before we make it unsigned
			e.g. int 3000000000 becomes long int rather than unsigned int
			this was an arbitrary decision and theoretically more costly,
			but avoids erroneous unsigning.  */
		
		if (tn.type == TYPE_I && (
			(yytext[0] == '+' && uval > INT_MAX) ||
			(yytext[0] == '-' && tn.val.i < INT_MIN) )) {
			tn.type = TYPE_LI;
		}

		if (tn.type == TYPE_LI && (
			(yytext[0] == '+' && uval > LONG_MAX) ||
			(yytext[0] == '-' && tn.val.i < LONG_MIN) )) {
			tn.type = TYPE_LLI;
		}

		if (tn.type == TYPE_LLI &&
			(yytext[0] == '+' && uval > LLONG_MAX)) {
			tn.type = TYPE_ULLI;
		}
	}	

	else { /* floating */
		tn.type = TYPE_D;
		tn.type += (yytext[yyleng-1] == 'L' || yytext[yyleng-1] == 'l');
		tn.type -= (yytext[yyleng-1] == 'F' || yytext[yyleng-1] == 'f');

		errno = 0;
		tn.val.f = strtold(yytext, NULL);

		if (errno == ERANGE) {/* ERROR */}

		/*	the above method of inferring necessary type adjustments
			does not apply here.  */
	}

	return tn;
}

int main(int argc, char const *argv[])
{
	int fileno, t;

	for (fileno = 1; fileno < argc; fileno++) {
		yyin = fopen(argv[fileno], "r");

		while (t = yylex()) {
			switch (t) {
				case IDENT:
					// printf("%s\t%d\t%s\t%s\n", argv[fileno], line, "STRING", (char *) yylval);
					break;
				/* etc etc */
				default:
					break;
			}
		}
	}
	
    return 0;
}
