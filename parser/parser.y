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
    ast_node_t *node;
} 
%code requires {
    #include "yylval.h"
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

terminal: expr ';' {$$ = $1};

expr: IDENT {$$ = new_ast_single(AST_IDENT, $1);}
|   NUM {$$ = new_ast_single(AST_NUM, $1);}
|   CHARLIT {$$ = new_ast_node(AST_CHARLIT, $1);}
|   ast_binop {$$ = $1;}
|   ast_ternop {$$ = $1;}
|   ast_unop {$$ = $1;}
|   ast_varlen {$$ = $1;}

;

ast_varlen: expr ',' expr {$$ = new_ast_node(AST_varlen, $1, $3);}
;

ast_binop: expr '+' expr
|   expr '-' expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr '*' expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr '/' expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr '%' expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr '>' expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr '<' expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr '=' expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr '&' expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr '|' expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr '!' expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr '^' expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr '~' expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|	expr SHL expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|	expr SHR expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr TIMESEQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr DIVEQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr MODEQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr PLUSEQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr MINUSEQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr SHLEQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr SHREQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr ANDEQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr OREQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr XOREQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|	expr GTEQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|	expr EQEQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|	expr NOTEQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|	expr LOGAND expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|	expr LOGOR expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|	expr LTEQ expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr '[' expr ']' {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr INDSEL expr {$$ = new_ast_node(AST_binop, $1, $3, $2);}
|   expr '.' '(' expr ')' {$$ = new_ast_node(AST_binop, $1, $3, $2);}
;

ast_ternop: expr '?' expr ':' expr {$$ = new_ast_node(AST_TERN, $1, $3, $5);}
;
ast_unop: expr "++" %prec POSTFIX {$$ = new_ast_node(AST_unop, $1, $2, POSTFIX);}
|   expr "--" %prec POSTFIX {$$ = new_ast_node(AST_UNOP, $1, $2, POSTFIX);}
|   "++" expr %prec PREFIX {$$ = new_ast_node(AST_UNOP, $1, $2, PREFIX);}
|   "--" expr %prec PREFIX {$$ = new_ast_node(AST_UNOP, $1, $2, PREFIX);}
|    '*' expr %prec SIZEOF {$$ = new_ast_node(AST_UNOP, $2, $1, PREFIX);}
|    '&' expr %prec SIZEOF  {$$ = new_ast_node(AST_UNOP, $2, $1, PREFIX);}
|   '(' expr ')' {$$ = $2}
|    '+' expr %prec SIZEOF  {$$ = new_ast_node(AST_UNOP, $2, $1, PREFIX);}
;
%%