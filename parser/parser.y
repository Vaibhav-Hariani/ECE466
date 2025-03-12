%{
     #include "parser.tab.h"
     int yylex(void);
     extern FILE *yyin;
 %}


//Undefined token, but lets parser.tab.h include everything
%token
TOKEOF	ELLIPSIS	
POUNDPOUND	AUTO	BREAK	CASE	CHAR	CONST	
CONTINUE	DEFAULT	DO	DOUBLE	ELSE	ENUM	
EXTERN	FLOAT	FOR	GOTO	IF	INLINE	INT	LONG	
REGISTER	RESTRICT	RETURN	SHORT	SIGNED	STATIC	
STRUCT	SWITCH	TYPEDEF	UNION	UNSIGNED	VOID	
VOLATILE	WHILE	BOOL	COMPLEX	IMAGINARY
%token 
    PLUSPLUS "++" 
    MINUSMINUS "--"
%left ','
%right '=' PLUSEQ MINUSEQ DIVEQ TIMESEQ MODEQ SHLEQ SHREQ ANDEQ OREQ XOREQ
%right '?' ':'	/* This is where yacc will put it */
%left LOGAND LOGOR
%left '&' '^' '|'
%left  EQEQ NOTEQ
%left GTEQ LTEQ '>' '<'
%left SHL SHR
%left '+' '-'
%left '*' '/' '%'
%right SIZEOF PREFIX '!' '~' 
%left '(' ')' '[' ']'  POSTFIX PLUSPLUS MINUSMINUS INDSEL '.'

%union {
	char *i;
	char c;
	TypedNumber n;
    SizedString s;
    ast_node *node;
} 
%code requires {
    #include "yylval.h"
    #include "ast_nodes.h"
    #include <stdio.h>
    void yyerror(const char * s);
}


%nterm <node> expr terminal ast_binop ast_ternop ast_unop ast_assign ast_lvalue 
%token <i> IDENT;
%token <c> CHARLIT;
%token <n> NUM;
%token <s> STRING;
%start terminal
%%
// 2 types of elements
// expr, and lvalues
// lvalues can be a type of expr, that reduce to an ident, or an address in memory
// as such, they can be ternarys, pointers, or identifiers. Nothing else.
//unops take in an lvalue, and do one of 3 operations to them.

terminal: %empty {$$=0;}
| terminal expr ';'  {$$ = print_ast($2);}
;


expr: NUM {$$ = new_ast_num($1);}
|   CHARLIT {$$ = new_ast_charlit($1);}
|   STRING {$$ = new_ast_string($1);}
|   ast_binop {$$ = $1;}
|   ast_unop {$$ = $1;}
|   ast_assign {$$=$1;}
|   ast_lvalue {$$=$1;}
|   '(' expr ')'            {$$=$2;}

;

ast_binop: expr '+' expr   { $$=new_ast_binop(AST_binop, $1, $3, '+');}
|    expr '-' expr   { $$=new_ast_binop(AST_binop, $1, $3, '-');}
|    expr '*' expr   { $$=new_ast_binop(AST_binop, $1, $3, '*');}
|    expr '/' expr   { $$=new_ast_binop(AST_binop, $1, $3, '/');}
|    expr '%' expr   { $$=new_ast_binop(AST_binop, $1, $3, '%');}
|    expr '>' expr   { $$=new_ast_binop(AST_binop, $1, $3, '>');}
|    expr '<' expr   { $$=new_ast_binop(AST_binop, $1, $3, '<');}
|	 expr '&' expr 	 { $$=new_ast_binop(AST_binop, $1, $3, '&');}
|	 expr '|' expr 	 { $$=new_ast_binop(AST_binop, $1, $3, '|');}
|    expr '^' expr   { $$=new_ast_binop(AST_binop, $1, $3, '^');}
|   expr ',' expr    { $$=new_ast_binop(AST_binop, $1, $3, ',');}
|	expr EQEQ expr 	     { $$=new_ast_binop(AST_binop, $1, $3, EQEQ);}
|	expr NOTEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, NOTEQ);}
|	expr LOGAND expr 	 { $$=new_ast_binop(AST_binop, $1, $3, LOGAND);}
|	expr LOGOR expr 	 { $$=new_ast_binop(AST_binop, $1, $3, LOGOR);}
|   expr LTEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, LTEQ);}
|	expr GTEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, GTEQ);}
//Special object type for objects with (potentially) 2 arguments, but aren't actually binops
|   expr '(' expr ')' { $$=new_ast_binop(AST_special, $1, $3, ')');};
|   expr '(' ')'    { $$=new_ast_binop(AST_special, $1, 0, ')');};
;


//separated here so theat lvalues can be handled properly later on in the system
ast_assign: expr '=' expr   { $$=new_ast_binop(AST_assign, $1, $3, '=');}
|   expr SHL expr 	 { $$=new_ast_binop(AST_assign, $1, $3, SHL);}
|	expr SHR expr 	 { $$=new_ast_binop(AST_assign, $1, $3, SHR);}
|	expr TIMESEQ expr 	 { $$=new_ast_binop(AST_assign, $1, $3, TIMESEQ);}
|	expr DIVEQ expr 	 { $$=new_ast_binop(AST_assign, $1, $3, DIVEQ);}
|	expr MODEQ expr 	 { $$=new_ast_binop(AST_assign, $1, $3, MODEQ);}
|	expr PLUSEQ expr 	 { $$=new_ast_binop(AST_assign, $1, $3, PLUSEQ);}
|	expr MINUSEQ expr 	 { $$=new_ast_binop(AST_assign, $1, $3, MINUSEQ);}
|	expr SHLEQ expr 	 { $$=new_ast_binop(AST_assign, $1, $3, SHLEQ);}
|	expr SHREQ expr 	 { $$=new_ast_binop(AST_assign, $1, $3, SHLEQ);}
|	expr ANDEQ expr 	 { $$=new_ast_binop(AST_assign, $1, $3, ANDEQ);}
|	expr OREQ expr 	     { $$=new_ast_binop(AST_assign, $1, $3, OREQ);}
|	expr XOREQ expr 	 { $$=new_ast_binop(AST_assign, $1, $3, XOREQ);}
;


ast_ternop: expr '?' expr ':' expr {$$=new_ast_ternop(AST_ternop, $1, $3, $5);};

ast_unop: expr "++" %prec POSTFIX {$$ = new_ast_unop($1, PLUSPLUS, POSTFIX);}
|   expr "--" %prec POSTFIX {$$ = new_ast_unop($1, MINUSMINUS, POSTFIX);}
|   "++" expr %prec PREFIX {$$ = new_ast_unop($2, PLUSPLUS, PREFIX);}
|   "--" expr %prec PREFIX {$$ = new_ast_unop($2, MINUSMINUS, PREFIX);}
|   '+' expr %prec SIZEOF  {$$ = new_ast_unop($2, '+', PREFIX);}
|   '-' expr %prec PREFIX {$$= new_ast_unop($2, '-', PREFIX);}
|   '!' expr %prec SIZEOF  {$$ = new_ast_unop($2, '!', PREFIX);}
|   '~' expr %prec SIZEOF  {$$ = new_ast_unop($2, '~', PREFIX);}
|   '&' expr %prec SIZEOF  {$$ = new_ast_unop($2, '&', PREFIX);}
|   SIZEOF expr {$$ = new_ast_unop($2, SIZEOF, PREFIX);}
;
//A hacky way of handling lvalues. They're nodes of other types, but just specified differently 
ast_lvalue: IDENT {$$ = new_ast_lvalue(new_ast_ident($1));}
|    '*' expr %prec SIZEOF {$$ = new_ast_lvalue(new_ast_unop($2, '*', PREFIX));}
|    expr INDSEL IDENT {$$ = new_ast_lvalue(new_ast_binop(AST_special, $1, new_ast_ident($3), INDSEL));}
|   expr '[' expr ']'  {$$ = new_ast_lvalue(new_ast_binop(AST_special, $1, $3, ']'));}
//Special case of array creation, for empty arrays.
|   expr '[' ']'    {$$ = new_ast_lvalue(new_ast_binop(AST_special, $1, 0, ']'));}
|   expr '.' IDENT  {$$ = new_ast_lvalue(new_ast_binop(AST_special, $1, new_ast_ident($3), '.'));}
| ast_ternop {$$ = new_ast_lvalue($1);}
;

/* keyword: STRUCT IDENT
| CHAR
| BOOL    :) slomp blup 
| COMPLEX
| mult_keyword COMPLEX
| IMAGINARY
| mult_keyword IMAGINARY

| 

mult_keyword: LONG
| DOUBLE
| FLOAT
| mult_keyword mult_keyword

;

storage_class: EXTERN
|   STRUCT
|   STATIC
|   VOLATILE
|   SIGNED
|   UNSIGNED
|   storage_class storage_class
|    */
%%

/* #ifdef YYDEBUG
    extern int yydebug = 1;
#endif */


void yyerror(const char *s){
    fprintf(stderr, "Error: %s \n", s);
}

int main(int argc, char** argv){
    FILE *file;
    if(argc < 2) {
        /* yyerror("No File Specified");
        return 0; */
        yyin = stdin;
        fprintf(stderr, "No File Specified \n");
    } else {
        file = fopen(argv[1],"r");
        if(!file) {
            yyerror("No valid file specified");
            return 0;
        }
        yyin = file;
    }
    yyparse();
        if(yyin != stdin) {
        fclose(file);    
    }

    return 0;
    /* yyparse();  */
} 