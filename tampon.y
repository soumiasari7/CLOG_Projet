%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}
%token idf mc_INTEGER mc_STRING mc_FLOAT mc_CHAR '{' '}' ';' ':' 
%%
s:idf '{' '{' ListeDeDeclaration '}' '{'  '}' {printf("Syntaxe correcte \n");}
;
ListeDeDeclaration: ListeDeDeclaration DeclarationVar |
;
DeclarationVar: type ':' idf ';'
;
type: mc_STRING | mc_INTEGER | mc_FLOAT | mc_CHAR
;
%%
main()
{
yyparse();
}
