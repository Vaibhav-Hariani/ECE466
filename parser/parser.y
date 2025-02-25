%start expr
%token IDENT
%token NUM
%token PLUSPLUS, MINUSMINUS
%token PLUSEQ, MINUSEQ, DIVEQ, TIMESEQ, MODEQ,SHLEQ,SHREQ, ANDEQ,OREQ,XOREQ
%right '='
%left '+' '-'
%left '*' '/'
%%
// 2 types of elements
// expr, and lvalues
// lvalues can be a type of expr, that reduce to an ident, or an address in memory
// as such, they can be ternarys, pointers, or identifiers. Nothing else.

//unops take in an lvalue, and do one of 3 operations to them.

expr: ast_binop
|  ast_ternop
|  ast_unop
|  ast_lvalue
|  NUM
|  IDENT
| '(' expr ')'
|    expr ',' expr
| expr ';'
    ;

ast_binop:   IDENT
|   NUM
| '(' expr ')'
| expr '+' expr
| expr '-' expr
| expr '*' expr
| expr '/' expr
;

ast_ternop:   IDENT
|   NUM
| '(' expr ')'
| expr '+' expr
| expr '-' expr
| expr '*' expr
| expr '/' expr
;


ast_unop: ast_lvalue
|  ast_lvalue PLUSPLUS {$$=$1; $1 = $1+1}
|  ast_lvalue MINUSMINUS
|  PLUSPLUS ast_lvalue
|  MINUSMINUS ast_lvalue
;

// ternops may need to be included separately for this

ast_lvalue: IDENT
| asterisks IDENT
| IDENT '[' expr ']'
| '&' IDENT
| expr '?' ast_lvalue ':' ast_lvalue
| '+' ast_lvalue
| '(' ast_lvalue ')'


asterisks: '*'
| '*' asterisks
;
%%