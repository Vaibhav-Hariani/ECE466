#ifndef AST_NODES_H
#define AST_NODES_H

#include "tokens-manual.h"
#include "yylval.h"
enum node_type {
    AST_binop=0,
    AST_ternop,
    AST_unop,
    AST_varlen,
    AST_ident,
    AST_literal,
    AST_num
};

enum order {
    PREFIX,
    POSTFIX
};


typedef union ast_node_t {
    struct binop;
    struct ternop;
    struct unop;
    struct varlen;
    //Non-recursive types can just live here
    char* charlit;
    TypedNumber* num;
    char* ident;
};

struct ast_node {
    //Reference to what obj is
    int type;
    //the object itself
    union ast_node_t* obj;   
} typedef ast_node;

struct binop {
    ast_node* expr_1;
    ast_node* expr_2;
    int opcode;
};

struct ternop {
    ast_node* expr_1;
    ast_node* expr_2;
    ast_node* expr_3;
};

struct varlen {
    ast_node* expr_1;
    ast_node* expr_2;
};

struct unop {
    ast_node* expr;
    int opcode;
    int sequence;
};

ast_node* new_ast_ident(char* c);
ast_node* new_ast_num(TypedNumber n);
ast_node* new_ast_charlit(char c);

ast_node* new_ast_binop(int type, ast_node* expr1, ast_node* expr2, int op);

ast_node* new_ast_ternop(int type, ast_node* expr1, ast_node* expr2, ast_node* expr3);

ast_node* new_ast_unop(ast_node* expr, int op, int dir);

ast_node* print_ast(ast_node* expr);

#endif