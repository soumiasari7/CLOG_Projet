%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}
%left '+' '*' '-' '/'
%token idf mc_INTEGER mc_STRING mc_FLOAT mc_CHAR mc_VECTOR mc_CONST valreal valint valints valchar valstr  affectaion '(' ')' '*' '/' '-' '+' '{' '}' '[' ']' ';' ':' '|' ','   
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
PartieCode : PartieCode Inst | Inst
;
Inst:Affectation  /*|| ES  CondIF | Boucle */ 
;
Affectation:idf affectaion Expression ';'
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

%%
main()
{
yyparse();
}
