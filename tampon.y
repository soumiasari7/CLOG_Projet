%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}
%left '+' '*' '-' '/'
%token dollar dieze ecom prcent mc_IF mc_ELSE mc_END mc_G mc_L mc_GE mc_LE mc_EQ mc_DI mc_NOT mc_AND mc_OR idf mc_INTEGER mc_STRING mc_FLOAT mc_CHAR mc_VECTOR mc_CONST mc_READ mc_DISPLAY mc_FOR valreal valint valints valchar valstr  affectaion '(' ')' '*' '/' '-' '+' '{' '}' '[' ']' ';' ':' '|' ',' '$' '%' '#' '&' '@' '"'  
%%
s:idf '{' '{' ListeDeDeclaration '}' '{' PartieCode '}' '}' { printf ("programme syntaxiquement juste"); YYACCEPT;}
;
/*=================partie déclaration =======================*/
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
Valeur: valreal | valint | valchar | valstr |valints |idf
;
/*=================partie code =======================*/
PartieCode : Affectation | ES | CondIF | Boucle |
;
 
/*========Affectation==========*/
Affectation:idf affectaion Expression ';' PartieCode 
;
Expression: Somme Soust
;
Soust:'+' Somme Soust|'-' Somme Soust|
;
Somme:Div Mul
;
Mul:'*' Div Mul |'/' Div Mul|
;
Div:'('Expression ')' | Valeur
;
/*========ES==========*/
ES: Entree PartieCode| Sortie PartieCode  
;
Entree:  mc_READ '(' SDF ':' '@' idf ')' ';' 
;
Sortie: mc_DISPLAY '('  valstr ':' idf ')' ';'
;
SDF: dieze | prcent | dollar | ecom
;
/*========CondIF==========*/
CondIF: mc_IF '(' condition ')' PartieCode else 
;
else : mc_ELSE PartieCode mc_END PartieCode |mc_END PartieCode
;
condition: '(' condition2 ')' OprLogique '(' condition2 ')' | mc_NOT '(' condition2 ')'|  condition2 
;
condition2: Expression OprComparaison Expression 
;
OprLogique: mc_AND | mc_OR
;
OprComparaison: mc_G | mc_DI | mc_EQ | mc_L |mc_LE | mc_GE
;
/*========Boucle==========*/
Boucle: mc_FOR '(' idf ':' PAS ':' CondArret ')' PartieCode mc_END PartieCode
;
PAS:valint
;
CondArret:idf
;
%%
main()
{
yyparse();
afficher();
}
