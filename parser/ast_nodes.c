#include "ast_nodes.h"
#include "parser.tab.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define new_ast_node calloc(1, sizeof(struct ast_node))

ast_node* new_ast_ident(char* c) {
  ast_node* node = new_ast_node;
  node->type = AST_ident;
  node->obj.ident = c;
  return node;
}

ast_node* new_ast_num(TypedNumber n) {
  ast_node* node = new_ast_node;
  node->type = AST_num;
  node->obj.num = &n;
  return node;
}

ast_node* new_ast_charlit(char c) {
  ast_node* node = new_ast_node;
  node->type = AST_charlit;
  node->obj.charlit = &c;
  return node;
}

ast_node* new_ast_lvalue(ast_node* expr){      
  struct lvalue* lval = calloc(1, sizeof(struct lvalue));
  lval ->expr = expr;  
  ast_node* node = new_ast_node;
  node->type=AST_lvalue;
  node->obj.l = lval;
  return expr;
}

ast_node* new_ast_binop(int type, ast_node* expr1, ast_node* expr2, int op) {
  ast_node* node = new_ast_node;
  switch (op) {
    case AST_binop:
      // if(expr1->type >= AST_charlit && expr2->type >= AST_charlit) {
      // These lines should handle num literal parsing
      // }
      struct binop* bin = calloc(1, sizeof(struct binop));
      node->type = AST_binop;
      bin->expr_1 = expr1;
      bin->expr_2 = expr2;
      bin->opcode = op;

      node->obj.b = bin;
      break;
    case AST_assign:    
      struct assign* obj = calloc(1, sizeof(struct assign));
      obj->lvalue = expr1;
      obj->rvalue = expr2;
      obj->opcode = op;

      node->type = AST_assign;
      node->obj.a = obj;

      //hackier lvalue handling
      if(expr1->type != AST_lvalue){
        printf("Invalid Expression: No lvalues \n");
        exit(1);
      }
      break;

    case AST_special:
      struct special* spec = calloc(1, sizeof(struct special));
      spec->expr_1 = expr1;
      spec->expr_2 = expr2;

      node->type = AST_special;
      node->obj.s = spec;
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
  node->obj.t = obj;
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
  print_recurse(expr, 0);
  return expr;
}


void print_recurse(ast_node* expr, int num_tabs) {
  char arr[num_tabs];
  char* c;

  memset(arr,'\t', num_tabs);
  fprintf(stderr, "%s", arr);
  switch (expr->type) {
    case AST_binop:
      struct binop* b = expr->obj.b;      
      if(b->opcode < 255){
        fprintf(stderr, "BINARY OP %c \n", b->opcode);
      } else fprintf(stderr, "BINARY OP %d \n", b->opcode);
      print_recurse(b->expr_1, num_tabs+1);
      print_recurse(b->expr_2, num_tabs+1);
          /* code */
          break;
    case AST_ternop:
      struct ternop* t = expr->obj.t;      
      fprintf(stderr, "TERNARY \n EXPR 1: \n");
      print_recurse(t->expr_1, num_tabs+1);
      fprintf(stderr, "EXPR 2: \n");
      print_recurse(t->expr_2, num_tabs+1);
      fprintf(stderr, "EXPR 3: \n");
      print_recurse(t->expr_3, num_tabs+1);
      break;
    case AST_unop:
      struct unop* u = expr->obj.u;      
      if(u->sequence == PREFIX){
        if(b->opcode < 255){
          fprintf(stderr, "UNARY OP %c PREFIX \n", b->opcode);
        }  else fprintf(stderr, "UNARY OP %d PREFIX \n", b->opcode);
      } else {
        if(b->opcode < 255){
          fprintf(stderr, "UNARY OP %c POSTFIX \n", b->opcode);
        }   else fprintf(stderr, "UNARY OP %d POSTFIX \n", b->opcode);
      }
      print_recurse(u->expr, num_tabs+1);  
      break;
    case AST_assign:
      struct assign* a = expr->obj.a; 
      if(a->opcode < 255){
        fprintf(stderr, "ASSIGNMENT %c, \n", a->opcode % 255);
      }     
      print_recurse(a->lvalue, num_tabs+1);
      print_recurse(a->rvalue, num_tabs+1);
      break;
    case AST_lvalue:
      struct lvalue* l = expr->obj.l;
      fprintf(stderr, "LVAL: \n");
      print_recurse(l->expr, num_tabs);
      break;
    case AST_charlit:
      c = expr->obj.charlit;
      fprintf(stderr, "CHARLIT %c: \n", *c);
      break;
    case AST_num:
      TypedNumber* n = expr->obj.num;
      fprintf(stderr, "NUMLIT %d: \n", n);
      break;
    case AST_ident:
      char* ident = expr->obj.ident;
      fprintf(stderr, "IDENT: %s \n", ident);
    case AST_special:
      struct special* s = expr->obj.s;
      fprintf(stderr, "FUNCTION CALL: \n");
      fprintf(stderr, "Function \n");
      print_recurse(s->expr_1, num_tabs+1);
      fprintf(stderr, "Parameters \n"); 
      print_recurse(s->expr_2, num_tabs+1);

    default:
      fprintf(stderr, "Unkown Expression Type: Failed \n");
      exit(1);
      break;
  }
}