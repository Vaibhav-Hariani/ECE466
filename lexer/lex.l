%option noyywrap
%{
#include "tokens-manual.h"
#include "yylval.h"
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include <errno.h>

YYSTYPE yylval;
char *filename;
int line;

char *new_filename();
char *literal_val();
TypedNumber number_val(char type);

%}

id		[A-Za-z_][A-Za-z0-9_]*

intsuf		(([Uu]?((L?L?)|(l?l?)))|(((L?L?)|(l?l?))[Uu]?))
octint		0[0-7]*{intsuf}
decint		[1-9][0-9]*{intsuf}
hexint		0[Xx][0-9A-Fa-f]+{intsuf}
deci2f		[0-9]+([Ee][\+-]?[0-9]+)[FLfl]?
hexi2f		0[Xx][0-9A-Fa-f]+([Pp][\+-]?[0-9]+)[FLfl]?
decflt		(([0-9]+\.[0-9]*)|([0-9]*\.[0-9]+))([Ee][\+-]?[0-9]+)?[FLfl]?
hexflt		0[Xx](([0-9A-Fa-f]+\.[0-9A-Fa-f]*)|([0-9A-Fa-f]*\.[0-9A-Fa-f]+))([Pp][\+-]?[0-9]+)?[FLfl]?

/* from here until str_lit defines: */
/*  char_const (ref C99 w.d. 6.4.4.4) */
/*  str_lit (ref C99 w.d. 6.5) */
simple_esc	\\[\'\"\?\\abfnrtv]
oct_esc		\\[0-7]?[0-7]?[0-7]?
hex_esc		\\x[0-9A-Fa-f]+
hex_quad	[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]
uni_char	\\(u|(U{hex_quad})){hex_quad}
esc_seq		{simple_esc}|{oct_esc}|{hex_esc}|{uni_char}

c_char		[^\'\\\n]|{esc_seq}
char_const	L?\'{c_char}+\'

s_char		[^\"\\\n]|{esc_seq}
str_lit		L?\"{s_char}*\"

preproc		"# "[01]" \""(.+)\".*\n
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

"."				{return('.');}
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
{char_const}	{yylval.s=literal_val(0);	return(CHARLIT);}
{str_lit}		{yylval.s=literal_val(1);	return(STRING);}
{octint}		{yylval.n=number_val('o');	return(NUMBER);}
{decint}		{yylval.n=number_val('i');	return(NUMBER);}
{hexint}		{yylval.n=number_val('h');	return(NUMBER);}
{deci2f}		{yylval.n=number_val('I');	return(NUMBER);}
{hexi2f}		{yylval.n=number_val('H');	return(NUMBER);}
{decflt}		{yylval.n=number_val('I');	return(NUMBER);}
{hexflt}		{yylval.n=number_val('H');	return(NUMBER);}

{preproc}		{filename=new_filename(); line=1;}
{newline}		{line++;}
{ws}			{/*empty*/}

%%

char *new_filename() {
	return strndup(yytext+5, strlen(yytext)-7);
}

char *literal_val(int is_str) {
	int i, char_done, buf_idx, oct_char;
	char *buf, *oct_esc, *oct_end;

	char_done = buf_idx = 0;

	/* not implementing wide chars */
	buf = (char *) calloc((is_str)? yyleng-2 : 1, sizeof(char));

	/* exclude '' and "" */
	for (i = 1 + (yytext[0] == 'L'); i < yyleng-1 && !char_done; i++) {
		if (yytext[i] == '\\') {
			/* esc seq start*/
			switch (yytext[++i]) { /* first char of esc seq */
				case '\'': case '\"': case '\\':
				case 'a': case 'b': case 'f':
				case 'n': case 'r': case 't':
				case 'v':
					buf[buf_idx++] = '\\';
					buf[buf_idx++] = yytext[i];
					break;
				case '\?':
					buf[buf_idx++] = yytext[i];
					break;
				case 'x':
					/* INCOMPLETE: handle hex esc seq */
					break;
				case 'u': case 'U':
					/* optional, unimplemented */
					break;
				default:
					oct_esc = (char *) calloc(3, sizeof(char));
					strncpy(oct_esc, yytext + i, 3);
					oct_char = strtol(oct_esc, &oct_end, 8);
					i += (oct_end == 0)? 2 : (oct_end - oct_esc) / sizeof(char) - 1;
					free(oct_esc);

					if (oct_char == 0) {
						// "\0" -> "\0"
						buf[buf_idx++] = '\\';
						buf[buf_idx++] = yytext[i];
					} else if (oct_char < 32 || oct_char >= 127) {
						// non-printable or beyond ASCII -> "\\%03o"
						sprintf(buf + buf_idx, "\\%03o", oct_char);
						buf_idx += 4;
					} else {
						buf[buf_idx++] = '\\';
						buf[buf_idx++] = (char) oct_char;
					}
					break;
			}
		} else { /* not in esc seq */
			buf[buf_idx++] = yytext[i];
		}
		char_done = !is_str;
	}

	return buf;
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
