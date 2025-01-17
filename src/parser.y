%{
#include <stdio.h>
#include <stdlib.h>
#include "semantic_check.h"
#include "code_gen.h"
#include "error_handling.h"

void yyerror(const char *s);
extern int yylineno;
int yylex(); // déclaration explicite de yylex
%}

%union {
    int num;
    char *str;
}

%token <num> NUMBER
%token <str> IDENTIFIER
%token VAR INSTR COLON SEMICOLON MOV ADD SUB MULT DIV COMMA

%type <str> declaration instruction operand
%type <str> var_section instr_section

%%
//structure principale du programme
program:
    var_section instr_section
;

//déclaration variables : cette genre de section commence par "Var :" se finie par ";"
var_section:
    VAR COLON declaration_list SEMICOLON
    {
        printf("variables section parsed successfully\n");
    }
  | VAR COLON error SEMICOLON
    {
        yyerror("invalid variable declaration section");
    }
;

//instructions : ces sections commencenr par "Instr :" finit par ";"
instr_section:
    INSTR COLON instruction_list SEMICOLON
    {
        printf("instructions section parsed successfully\n");
    }
  | INSTR COLON error SEMICOLON
    {
        yyerror("invalid instruction section");
    }
;


declaration_list:
    declaration
  | declaration_list declaration
;

declaration:
    IDENTIFIER COLON IDENTIFIER
    {
        add_variable($1, $3);
        printf("variable declared: %s of type %s\n", $1, $3);
    }
;

instruction_list:
    instruction
  | instruction_list instruction
;

instruction:
    MOV IDENTIFIER COMMA operand
    {
        check_variable($2);
        generate_mov($2, $4);
    }
  | ADD IDENTIFIER COMMA operand
    {
        check_variable($2);
        generate_add($2, $4);
    }
  | SUB IDENTIFIER COMMA operand
    {
        check_variable($2);
        generate_sub($2, $4);
    }
;

operand:
    IDENTIFIER
    {
        check_variable($1);
        $$ = $1;
    }
  | NUMBER
    {
        $$ = malloc(20); // allouer de la mémoire pour stocker la valeur sous forme de chaîne
        sprintf($$, "%d", $1);
    }
;

%%
//fonction pour afficher les erreurs
void yyerror(const char *s) {
    fprintf(stderr, "syntax error at line %d: %s\n", yylineno, s);
}
