%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}
%token idf mc_INTEGER mc_STRING mc_FLOAT mc_CHAR mc_VECTOR mc_CONST valreal valint valchar valstr affectaion '{' '}' '[' ']' ';' ':' '|' ',' '-' '+' '*' '/'
%%
s:idf '{' '{' ListeDeDeclaration '}' '{' PartieCode '}' '}' { printf ("programme syntaxiquement juste"); YYACCEPT;}
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
PartieCode: Affectation /* | ES | CondIF | Boucle */
;
Affectation:idf affectaion Expression ';' | idf affectaion Valeur ';' | idf affectaion idf ';'
;
Expression: Somme | Div /* | Soustraction | Multiplication */
;
/* je ne pas trait tout les cas comme:idf + valint ..... */
Somme: idf '+' idf | valint '+' valint | valreal '+' valreal 
;
Div: idf '/' idf | valint '/' valint | valreal '/' valreal 
;
%%
main()
{
yyparse();
}
