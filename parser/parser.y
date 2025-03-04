%start terminal
%token 
    PLUSPLUS "++" 
    MINUSMINUS "--"
%left ','
%right '=' PLUSEQ MINUSEQ DIVEQ TIMESEQ MODEQ SHLEQ SHREQ ANDEQ OREQ XOREQ
%right '?' ':'
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
	char *s;
	char c;
	TypedNumber n;
    ast_node *node;
} 
%code requires {
    #include "yylval.h"
    #include "ast_nodes.h"
}


%nterm <node> expr terminal ast_binop ast_ternop ast_unop ast_varlen;
%token <s> IDENT;
%token <c> CHARLIT;
%token <n> NUM;

%%
// 2 types of elements
// expr, and lvalues
// lvalues can be a type of expr, that reduce to an ident, or an address in memory
// as such, they can be ternarys, pointers, or identifiers. Nothing else.
//unops take in an lvalue, and do one of 3 operations to them.

terminal: expr ';' {$$ = print_ast($1);};

expr: IDENT {$$ = new_ast_ident($1);}
|   NUM {$$ = new_ast_num($1);}
|   CHARLIT {$$ = new_ast_charlit($1);}
|   ast_binop {$$ = $1;}
|   ast_ternop {$$ = $1;}
|   ast_unop {$$ = $1;}
|   ast_varlen {$$ = $1;}

;

ast_varlen: expr ',' expr {$$ = new_ast_binop(AST_varlen, $1, $3, ',');}
;

ast_binop: expr '+' expr   { $$=new_ast_binop(AST_binop, $1, $3, '+');}
|    expr '-' expr   { $$=new_ast_binop(AST_binop, $1, $3, '-');}
|    expr '*' expr   { $$=new_ast_binop(AST_binop, $1, $3, '*');}
|    expr '/' expr   { $$=new_ast_binop(AST_binop, $1, $3, '/');}
|    expr '%' expr   { $$=new_ast_binop(AST_binop, $1, $3, '%');}
|    expr '>' expr   { $$=new_ast_binop(AST_binop, $1, $3, '>');}
|    expr '<' expr   { $$=new_ast_binop(AST_binop, $1, $3, '<');}
|    expr '=' expr   { $$=new_ast_binop(AST_binop, $1, $3, '=');}
|	 expr '&' expr 	 { $$=new_ast_binop(AST_binop, $1, $3, '&');}
|	 expr '|' expr 	 { $$=new_ast_binop(AST_binop, $1, $3, '|');}
|    expr '^' expr   { $$=new_ast_binop(AST_binop, $1, $3, '^');}
|	expr SHL expr 	 { $$=new_ast_binop(AST_binop, $1, $3, SHL);}
|	expr SHR expr 	 { $$=new_ast_binop(AST_binop, $1, $3, SHR);}
|   expr LTEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, LTEQ);}
|	expr GTEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, GTEQ);}
|	 expr TIMESEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, TIMESEQ);}
|	 expr DIVEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, DIVEQ);}
|	 expr MODEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, MODEQ);}
|	 expr PLUSEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, PLUSEQ);}
|	 expr MINUSEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, MINUSEQ);}
|	 expr SHLEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, SHLEQ);}
|	 expr SHREQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, SHREQ);}
|	 expr ANDEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, ANDEQ);}
|	 expr OREQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, OREQ);}
|	 expr XOREQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, XOREQ);}
|	 expr EQEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, EQEQ);}
|	 expr NOTEQ expr 	 { $$=new_ast_binop(AST_binop, $1, $3, NOTEQ);}
|	 expr LOGAND expr 	 { $$=new_ast_binop(AST_binop, $1, $3, LOGAND);}
|	 expr LOGOR expr 	 { $$=new_ast_binop(AST_binop, $1, $3, LOGOR);}
|   expr INDSEL expr     { $$ = new_ast_binop(AST_binop, $1, $3, INDSEL);}
//The '[' token corresponds solely to array index search
|   expr '[' expr ']'    {$$ = new_ast_binop(AST_binop, $1, $3, '[');}
//The '(' token corresponds soley to function calls
|   expr '.' '(' expr ')' {$$ = ast_binops(AST_binop, $1, $4, '(');}
;

ast_ternop: expr '?' expr ':' expr {$$ = new_ast_ternop(AST_ternop, $1, $3, $5);}
;
ast_unop: expr "++" %prec POSTFIX {$$ = new_ast_unop($1, PLUSPLUS, POSTFIX);}
|   expr "--" %prec POSTFIX {$$ = new_ast_unop($1, MINUSMINUS, POSTFIX);}
|   "++" expr %prec PREFIX {$$ = new_ast_unop($2, PLUSPLUS, PREFIX);}
|   "--" expr %prec PREFIX {$$ = new_ast_unop($2, MINUSMINUS, PREFIX);}
|    '*' expr %prec SIZEOF {$$ = new_ast_unop($2, '*', PREFIX);}
|    '&' expr %prec SIZEOF  {$$ = new_ast_unop($2, '&', PREFIX);}
|   '(' expr ')' {$$ = $2}
|    '+' expr %prec SIZEOF  {$$ = new_ast_unop($2, '+', PREFIX);}
|    '!' expr %prec SIZEOF  {$$ = new_ast_unop($2, '!', PREFIX);}
|    '~' expr %prec SIZEOF  {$$ = new_ast_unop($2, '~', PREFIX);}
;
%%