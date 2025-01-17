%{
#include "parser.h"
#include <stdio.h>
%}

%option noyywrap noinput nounput


DIGIT       [0-9]+
ID          [a-zA-Z_][a-zA-Z0-9_]*

%%

"Var"       { return VAR; }
"Instr"     { return INSTR; }


"mov"       { return MOV; }
"add"       { return ADD; }
"sub"       { return SUB; }
"mult"      { return MULT; }
"div"       { return DIV; }


";"         { return SEMICOLON; }
","         { return COMMA; }
":"         { return COLON; }


{ID}        { yylval.str = strdup(yytext); return IDENTIFIER; }
{DIGIT}     { yylval.num = atoi(yytext); return NUMBER; }


[ \t\n]+    ;


.           { fprintf(stderr, "unexpected character: %s\n", yytext); }
%%
