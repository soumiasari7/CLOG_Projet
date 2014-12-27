%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
char suavType [30];
%}
%union {
int num;
char* str;
   }
%left '+' '*' '-' '/'
%token dollar dieze ecom prcent mc_IF mc_ELSE mc_END mc_G mc_L mc_GE mc_LE mc_EQ mc_DI mc_NOT mc_AND mc_OR <str>idf mc_INTEGER mc_STRING mc_FLOAT mc_CHAR mc_VECTOR mc_CONST mc_READ mc_DISPLAY mc_FOR 
%token valreal <num>valint valints valchar valstr  
%token affectaion '(' ')' '*' '/' '-' '+' '{' '}' '[' ']' ';' ':' '|' ',' '$' '%' '#' '&' '@' '"' 
%type <>Expression
%type <>Valeur 
%%
s:idf '{' '{' ListeDeDeclaration '}' '{' PartieCode '}' '}' { printf ("programme syntaxiquement juste"); YYACCEPT;}
;
/*=================partie déclaration =======================*/
ListeDeDeclaration : DeclarationVarSimple| DeclarationTab| DeclarationConst 
;
DeclarationVarSimple : TYPE ':' Listeparam ';' DeclarationVarSimple ListeDeDeclaration | TYPE ':' Listeparam ';'
;
Listeparam: Listeparam '|' idf { if (doubleDeclaration($3)==1)insererType($3,suavType);
                                 else printf("erreur Sémantique: double déclation de %s, à la ligne %d\n", $3, nb_ligne); }
          | idf  { if ( doubleDeclaration($1)==1)insererType($1,suavType);
                                 else printf("erreur Sémantique: double déclation de %s, à la ligne %d\n", $1, nb_ligne);}
;
DeclarationTab: mc_VECTOR ':' TYPE ':' idf '[' idf ',' idf ']' ';' DeclarationTab ListeDeDeclaration { if (doubleDeclaration($5)==1)insererType($5,suavType);
                                                                                                      else printf("erreur Sémantique: double déclation de %s, à la ligne %d\n", $5, nb_ligne);}
								                                                                     { if (doubleDeclaration($7)==1)insererType($7,suavType);
                                                                                                     else printf("erreur Sémantique: double déclation de %s, à la ligne %d\n", $7, nb_ligne); }
								                                                                     { if (doubleDeclaration($9)==1)insererType($9,suavType);
                                                                                                      else printf("erreur Sémantique: double déclation de %s, à la ligne %d\n", $9, nb_ligne);}
              |
;
DeclarationConst: mc_CONST ':' idf affectaion Valeur ';' DeclarationConst ListeDeDeclaration { if (doubleDeclaration($3)==1)insererType($3,suavType);
                                                                                              else printf("erreur Sémantique: double déclation de %s, à la ligne %d\n", $3, nb_ligne); }
                |
;
TYPE: mc_STRING  {strcpy(suavType,$1); }
    | mc_INTEGER {strcpy(suavType,$1); }
	| mc_FLOAT   {strcpy(suavType,$1); }
	| mc_CHAR    {strcpy(suavType,$1); }
;
Valeur: valreal | valint | valchar | valstr |valints |idf
;
/*=================partie code =======================*/
PartieCode : Affectation | ES | CondIF | Boucle |
;
 
/*========Affectation==========*/
Affectation:idf affectaion Expression ';' PartieCode 
;
Expression:Valeur { $$=$1; }
          | Expression '+' Expression { $$=$1+$3; }
          | Expression '-' Expression { $$=$1-$3; }
          | Expression '*' Expression { $$=$1-$3; }
          | Expression '/' Expression { if ($3==0){printf("erreur Sémantique: div par zero à la ligne %d\n", nb_ligne);}
            else $$=$1/$3; }
          | '(' Expression ')' {$$ = $2;}
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
