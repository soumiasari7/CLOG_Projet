%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}
%token idf mc_INTEGER mc_STRING mc_FLOAT mc_CHAR '{' '}' ';' ':' '|'
%%
s:idf '{' '{' ListeDeDeclaration '}' '{'  '}' '}' { printf ("programme syntaxiquement juste"); YYACCEPT;}
;
ListeDeDeclaration: TYPE ':' Listeparam ';' ListeDeDeclaration | TYPE ':' Listeparam ';'
;
Listeparam: Listeparam '|' idf | idf
;
TYPE: mc_STRING | mc_INTEGER | mc_FLOAT | mc_CHAR
;
%%
main()
{
yyparse();
}
