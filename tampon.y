%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}
%token idf mc_INTEGER mc_STRING mc_FLOAT mc_CHAR mc_VECTOR mc_CONST valreal valint valchar valstr affectaion '{' '}' '[' ']' ';' ':' '|' ','
%%
s:idf '{' '{' ListeDeDeclaration '}' '{'  '}' '}' { printf ("programme syntaxiquement juste"); YYACCEPT;}
;
ListeDeDeclaration : DeclarationVarSimple| DeclarationTab| DeclarationConst 
;
DeclarationVarSimple : TYPE ':' Listeparam ';' DeclarationVarSimple ListeDeDeclaration | TYPE ':' Listeparam ';'
;
Listeparam: Listeparam '|' idf | idf
;
DeclarationTab: mc_VECTOR ':' TYPE ':' idf '[' idf ',' idf ']' ';' DeclarationTab ListeDeDeclaration|
;
DeclarationConst: mc_CONST ':' idf affectaion Valeur ';' DeclarationConst ListeDeDeclaration|
;
TYPE: mc_STRING | mc_INTEGER | mc_FLOAT | mc_CHAR
;
Valeur: valreal | valint | valchar | valstr
;
%%
main()
{
yyparse();
}
