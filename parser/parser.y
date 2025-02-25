%start expr
%token IDENT
%token NUM
%token 
    PLUSPLUS "++" 
    MINUSMINUS "--"
%left ','
%right '=' PLUSEQ MINUSEQ DIVEQ TIMESEQ MODE SHLEQ SHREQ ANDEQ OREQ XOREQ
%right '?' ':'
%left '+' '-'
%left '*' '/' '%'
%right SIZEOF PREFIX 
%left '(' ')' '[' ']'  POSTFIX PLUSPLUS MINUSMINUS

%%
// 2 types of elements
// expr, and lvalues
// lvalues can be a type of expr, that reduce to an ident, or an address in memory
// as such, they can be ternarys, pointers, or identifiers. Nothing else.

//unops take in an lvalue, and do one of 3 operations to them.

expr: IDENT
|   ast_binop
|   ast_ternop
|   ast_unop
|   NUM
|   '(' expr ')'
|    expr ',' expr    
|    '*' expr %prec SIZEOF
|    expr '[' expr ']'
|    '+' expr %prec SIZEOF
|   expr '=' expr
|   expr PLUSEQ expr
|   expr MINUSEQ expr
|   expr DIVEQ expr
;

ast_binop: expr '+' expr
|   expr '-' expr
|   expr '*' expr
|   expr '/' expr
;

ast_ternop: expr '?' expr ':' expr;

ast_unop: expr "++" %prec POSTFIX
|   expr "--" %prec POSTFIX
|   "++" expr %prec PREFIX
|   "--" expr %prec PREFIX
;
%%