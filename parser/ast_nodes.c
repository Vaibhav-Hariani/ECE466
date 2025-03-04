#include "ast_nodes.h"

#include <stdio.h>
#include <stdlib.h>

#include "tokens-manual.h"

#define new_ast_node calloc(1,sizeof(struct ast_node))

ast_node* new_ast_ident(char* c) {
  ast_node* node = new_ast_node;
  node->type = AST_ident;
  node -> obj = c;
  return node;
}

ast_node* new_ast_num(TypedNumber n){
  ast_node* node = new_ast_node;
  node->type = AST_ident;
  node -> obj = &n;
  return node;
}

ast_node* new_ast_charlit(char c) {
  ast_node* node = new_ast_node;
  node->type = AST_ident;
  node -> obj = &c;
  return node;
}


ast_node* new_ast_binop(int type, ast_node* expr1, ast_node* expr2, int op) {
  ast_node* node = new_ast_node;
  switch (op) {
    case AST_binop:
      struct binop* obj = calloc(1, sizeof(struct binop));
      node->type = AST_binop;
      node ->obj = obj;
      obj->expr_1 = expr1;
      obj->expr_2 = expr2;
      obj->opcode = op;    
      break;

      case AST_varlen:
      struct varlen* obj = calloc(1, sizeof(struct varlen));
      node->type = AST_varlen;
      node ->obj = obj;
      obj->expr_1 = expr1;
      obj->expr_2 = expr2;
      break;

      default:
      printf("Something went wrong");
      exit(1);
      break;  
  }
  return node;

}

ast_node* new_ast_ternop(int type, ast_node* expr1, ast_node* expr2, ast_node* expr3){
  ast_node* node = new_ast_node;
  node->type = AST_ternop;
  struct ternop* obj = calloc(1, sizeof(struct ternop));
  obj -> expr_1 = expr1;
  obj -> expr_2 = expr2;
  obj -> expr_3 = expr3;
  node-> obj = obj;  
  return node;

}

ast_node* new_ast_unop(ast_node* expr, int op, int dir) {
  ast_node* node = new_ast_node;
  node->type = AST_unop;
  struct unop* obj = calloc(1, sizeof(struct unop));
  obj -> expr = expr;
  obj -> opcode = op;
  obj ->sequence = dir;
  return node;
}

ast_node* print_ast(ast_node* expr);
