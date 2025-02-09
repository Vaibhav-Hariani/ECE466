%start expr
%token IDENT
%token NUM
%right '='
%left '+' '-'
%left '*' '/'
%%
expr:   IDENT
|   NUM
| '(' expr ')'
| expr '+' expr
| expr '-' expr
| expr '*' expr
| expr '/' expr
;
%%