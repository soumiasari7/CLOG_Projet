%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYDEBUG 1
char suavType [30];
int nb_ligne=1;
int nb_col=1;
%}
%union {
int num;
char* str;
   }
%left '+' '-'
%left '*' '/'
%token dollar dieze ecom prcent mc_IF mc_ELSE mc_END mc_G mc_L mc_GE mc_LE mc_EQ mc_DI mc_NOT mc_AND mc_OR <str>idf mc_INTEGER mc_STRING mc_FLOAT mc_CHAR mc_VECTOR mc_CONST mc_READ mc_DISPLAY mc_FOR 
%token <num>valreal <num>valint <str>valchar <str>varstrdo <str>varstrpr <str>varstrdz <str>varstrecm <str>valstr  
%token affectaion '(' ')' '*' '/' '-' '+' '{' '}' '[' ']' ';' ':' '|' ',' '@' '"' 
%type <num> ValeurNum Expression 
%type <str>Valeurcar



%%
s:idf '{' '{' ListeDeDeclaration '}' '{' PartieCode '}' '}' { printf ("programme syntaxiquement juste"); YYACCEPT;}
;
/*=================partie déclaration =======================*/
ListeDeDeclaration : DeclarationVarSimple| DeclarationTab| DeclarationConst 
;
DeclarationVarSimple : TYPE ':' Listeparam ';' DeclarationVarSimple ListeDeDeclaration | TYPE ':' Listeparam ';'
;
Listeparam: Listeparam '|' idf {
                     if (doubleDeclaration($3)==1){insererType($3,suavType); }
                        else printf("erreur Sémantique: double déclation de %s, à la ligne %d\n", $3, nb_ligne);
						}
                        | idf  {
						if ( doubleDeclaration($1)==1)insererType($1,suavType);
                                 else printf("erreur Sémantique: double déclation de %s, à la ligne %d, colon %d\n", $1, nb_ligne,nb_col);}
;
DeclarationTab: mc_VECTOR ':' TYPE ':' idf '[' ValeurNum ',' ValeurNum ']' ';' DeclarationTab ListeDeDeclaration 
              { {if(doubleDeclaration($5)==1){insererType($5,suavType);}
                 else printf("erreur Sémantique: double déclation de %s, à la ligne %d\n", $5, nb_ligne);}
			 
			 if (TabDepassBorn($7,$9)==0) printf("erreur Sémantique: Bornne inf depasseer la taille de %s, à la ligne %d\n",   $5,nb_ligne);
			 }	
              |
;
DeclarationConst: mc_CONST ':' idf affectaion Valeur ';' DeclarationConst ListeDeDeclaration {
 if (doubleDeclaration($3)==1) {insererType($3,suavType);/*insereVal($3,$5);*/}
 else printf("erreur Sémantique: double déclaration de %s, à la ligne %d\n", $3, nb_ligne); }
                |
;
TYPE: mc_STRING  {strcpy(suavType,$1); }
    | mc_INTEGER {strcpy(suavType,$1); }
	| mc_FLOAT   {strcpy(suavType,$1); }
	| mc_CHAR    {strcpy(suavType,$1); }
	| mc_CONST    {strcpy(suavType,$1); }
;
Valeur: ValeurNum 
       | Valeurcar 
;
Valeurcar: valchar 
          | valstr
;
ValeurNum : valreal  
           | valint 
;
/*=================partie code =======================*/
PartieCode : Affectation | ES | CondIF | Boucle |
;
 
/*========Affectation==========*/
Affectation:idf affectaion Expression ';' PartieCode 
 { if (nonDeclaration($1)==0) printf("erreur Sémantique: Non déclaration de %s, à la ligne %d\n", $1, nb_ligne);
 
  }
 
|idf affectaion idf ';' PartieCode {insereVal($1,$3); if (Compatible($1,$3)==0) printf("erreur Sémantique:Type non Compatible , à la ligne %d\n", nb_ligne);}
|idf affectaion ValeurNum ';' PartieCode {insereVal($1,$3);}
|idf affectaion valchar ';' PartieCode{insereVal($1,$3);}
|idf affectaion valstr ';' PartieCode{insereVal($1,$3);}
;
Expression:ValeurNum { $$=$1;  }
          |idf {$$=retournerVal($1);if (nonDeclaration($1)==0) printf("erreur Sémantique: Non déclaration de %s, à la ligne %d\n", $1, nb_ligne); }
          | Expression '+' Expression {$$=$1+$3; } 
          | Expression '-' Expression {$$=$1-$3;} 
          | Expression '*' Expression {$$=$1*$3;} 
          | Expression '/' Expression {if ($3==0) printf("erreur Sémantique: div par zero à la ligne %d,colon: %d\n", nb_ligne,nb_col);
                                        else $$=$1/$3;
									  }
                                     
          | '(' Expression ')' {$$ = $2;}
;
/*========ES==========*/
ES: Entree PartieCode| Sortie PartieCode  
;
Entree:  mc_READ '(' ecom ':' '@' idf ')' ';' { if (nonDeclaration($6)==0) printf("erreur Sémantique: Non déclaration de %s, à la ligne %d\n", $6, nb_ligne);
if (Form($6)!=3) printf("erreur Sémantique: mal formate, à la ligne %d\n", nb_ligne);  }


| mc_READ '(' dieze ':' '@' idf ')' ';' {
if (Form($6)!=1) printf("erreur Sémantique: mal formate, à la ligne %d\n", nb_ligne);  }

| mc_READ '(' dollar ':' '@' idf ')' ';' {
if (Form($6)!=0) printf("erreur Sémantique: mal formate, à la ligne %d\n", nb_ligne);  }

|mc_READ '(' prcent ':' '@' idf ')' ';'{
if (Form($6)!=2) printf("erreur Sémantique: mal formate, à la ligne %d\n", nb_ligne);  }
;
Sortie: mc_DISPLAY '('  varstrdo ':' idf ')' ';'
{ if (nonDeclaration($5)==0)printf("erreur Sémantique: Non déclaration de %s, à la ligne %d\n", $5, nb_ligne);
if (Form($5)!=0) printf("erreur Sémantique:  display mal formate, à la ligne %d\n", nb_ligne);  }

| mc_DISPLAY '('  varstrdz ':' idf ')' ';'
{ if (nonDeclaration($5)==0)printf("erreur Sémantique: Non déclaration de %s, à la ligne %d\n", $5, nb_ligne);
 if (Form($5)!=1) printf("erreur Sémantique:  display mal formate, à la ligne %d\n", nb_ligne);  }

| mc_DISPLAY '('  varstrpr ':' idf ')' ';'
{ if (nonDeclaration($5)==0)printf("erreur Sémantique: Non déclaration de %s, à la ligne %d\n", $5, nb_ligne);
 if (Form($5)!=2) printf("erreur Sémantique:  display mal formate, à la ligne %d\n", nb_ligne);  }

|mc_DISPLAY '('  varstrecm ':' idf ')' ';'
{ if (nonDeclaration($5)==0)printf("erreur Sémantique: Non déclaration de %s, à la ligne %d\n", $5, nb_ligne);
 if (Form($5)!=3) printf("erreur Sémantique:  display mal formate, à la ligne %d\n", nb_ligne);  } 
 
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
Boucle: mc_FOR '(' idf ':' PAS ':' CondArret ')' PartieCode mc_END PartieCode { if (nonDeclaration($3)==0)printf("erreur Sémantique: Non déclaration de %s, à la ligne %d\n", $3, nb_ligne);} 
;
PAS:valint
;
CondArret:idf { if (nonDeclaration($1)==0)printf("erreur Sémantique: Non déclaration de %s, à la ligne %d\n", $1, nb_ligne);} 
;
%%
main()
{
yyparse();
afficher();
}
