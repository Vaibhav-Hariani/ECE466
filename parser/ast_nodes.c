#include "ast_nodes.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define new_ast_node calloc(1, sizeof(struct ast_node))

ast_node* new_ast_ident(char* c) {
  ast_node* node = new_ast_node;
  node->type = AST_ident;
  node->obj->ident = c;
  return node;
}

ast_node* new_ast_num(TypedNumber n) {
  ast_node* node = new_ast_node;
  node->type = AST_num;
  node->obj->num = &n;
  return node;
}

ast_node* new_ast_charlit(char c) {
  ast_node* node = new_ast_node;
  node->type = AST_charlit;
  node->obj->charlit = &c;
  return node;
}

ast_node* new_ast_lvalue(ast_node* expr){      
  ast_node* node = new_ast_node;
  node->type=AST_lvalue;
  ast_node* cnode = new_ast_node;  
  node->obj = expr;
  return expr;
}

ast_node* new_ast_binop(int type, ast_node* expr1, ast_node* expr2, int op) {
  ast_node* node = new_ast_node;
  switch (op) {
    case AST_binop:
      // if(expr1->type >= AST_charlit && expr2->type >= AST_charlit) {
      // These lines should handle num literal parsing
      // }
      struct binop* obj = calloc(1, sizeof(struct binop));
      node->type = AST_binop;
      node->obj = obj;
      obj->expr_1 = expr1;
      obj->expr_2 = expr2;
      obj->opcode = op;
      break;
    case AST_assign:    
      struct assign* obj = calloc(1, sizeof(struct assign));
      node->type = AST_assign;
      node->obj = obj;
      obj->lvalue = expr1;
      obj->rvalue = expr2;
      obj->opcode = op;

      //hackier lvalue handling
      if(expr1->type != AST_lvalue){
        printf("Invalid Expression: No lvalues \n");
        exit(1);
      }
      break;

    case AST_special:
      struct special* obj = calloc(1, sizeof(struct special));
      node->type = AST_special;
      node->obj = obj;
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

ast_node* new_ast_ternop(int type, ast_node* expr1, ast_node* expr2,
                         ast_node* expr3) {
  ast_node* node = new_ast_node;
  node->type = AST_ternop;
  struct ternop* obj = calloc(1, sizeof(struct ternop));
  obj->expr_1 = expr1;
  obj->expr_2 = expr2;
  obj->expr_3 = expr3;
  node->obj = obj;
  return node;
}

ast_node* new_ast_unop(ast_node* expr, int op, int dir) {
  ast_node* node = new_ast_node;
  node->type = AST_unop;
  struct unop* obj = calloc(1, sizeof(struct unop));
  obj->expr = expr;
  obj->opcode = op;
  obj->sequence = dir;
  return node;
}

ast_node* print_ast(ast_node* expr) {
  ast_node* ret = expr;
  print_ast_recursive(expr, 0);
  return ret;
}


void print_recurse(ast_node* expr, int num_tabs) {
  char arr[num_tabs];
  memset(arr,'\t', num_tabs);
  fprintf(stderr, "%s", arr);
  switch (expr->type) {
    case AST_binop:
      struct binop* b = expr->obj;      
      fprintf(stderr, "BINARY OP %c \n", b->opcode);
      print_recurse(b->expr_1, num_tabs+1);
      print_recurse(b->expr_2, num_tabs+1);
          /* code */
          break;
    case AST_ternop:
      break;
    case AST_unop:
      break;
    case AST_assign:
      struct assign* v = expr->obj;      
      fprintf(stderr, "BINARY OP, \n");
      print_recurse(v->lvalue, num_tabs+1);
      print_recurse(v->rvalue, num_tabs+1);
      break;
    case AST_lvalue:
      break;
    case AST_charlit:
      break;
    case AST_num:
      break;

    default:
      fprintf(stderr, "Unkown Expression Type: Failed \n");
      exit(1);
      break;
  }
}