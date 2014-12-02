%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tampon.tab.h"
int nb_ligne=1; 

//déclaration d'une structure de donnée pour la table de symbole
typedef struct
{
char NomEntite[30];
char CodeEntite[30];
} TypeTS;

//initiation d'un tableau qui va contenir les elements de la table de symbole
TypeTS ts[200]; 

// un compteur global pour la table de symbole
int CpTabSym=0;


//une fonctione recherche: pour chercher est ce que l'entité existe ou non déjà dans la table de symbole.
// i: l'entite existe dejà dans la table de symbole, et sa position est i, -1: l'entité n'existe pas dans la table de symbole.

int recherche(char entite[])
{
int i=0;
while(i<CpTabSym)
{
if (strcmp(entite,ts[i].NomEntite)==0) return i;
i++;
}
return -1;
}

//une fontion qui va insérer les entités de programme dans la table de symbole
void inserer(char entite[], char code[])
{
if ( recherche(entite)==-1)
{
strcpy(ts[CpTabSym].NomEntite,entite); 
strcpy(ts[CpTabSym].CodeEntite,code);
CpTabSym++;
}
}

//une fonction pour afficher la table de symbole
void afficher ()
{
printf("\n/********************Table des symboles ************************/\n");
printf("___________________________________________________________________\n");
printf("|            NomEntite           |          CodeEntite            |\n");
printf("____________________________________________________________________\n");
int i=0;
  while(i<CpTabSym)
  {
    printf("| %30s | %30s |\n",ts[i].NomEntite,ts[i].CodeEntite);

    i++;
   }
printf("___________________________________________________________________\n");
}
%}  

chiffre0[0-9]
chiffre1 [1-9]
valint ({chiffre1}{chiffre0}*|0)
valints "([+-]"({chiffre1}{chiffre0}*)")"|0
valrel ({chiffre1}{chiffre0}*|0)"."({chiffre0}*)
valrels "([+-]"({chiffre1}{chiffre0}*|0)"."({chiffre0}*)")"
varchar '.'
varstr \"(.)*\"
affect =
idf [A-Z]([a-z]|{chiffre0})*
%%
INTEGER {inserer(yytext,"mc_INTEGER"); return mc_INTEGER; }
FLOAT {inserer(yytext,"mc_FLOAT"); return mc_FLOAT;}
CHAR {inserer(yytext,"mc_CHAR"); return mc_CHAR;}
STRING {inserer(yytext,"mc_STRING"); return mc_STRING;}
VECTOR {inserer(yytext,"mc_VECTOR"); return mc_VECTOR;}
CONST {inserer(yytext,"mc_CONST"); return mc_CONST;}
{idf} {if (yyleng<=8) {inserer(yytext,"IDF");return idf; }
       else {printf("Erreur lexical:IDF trop long ---> ");ECHO;
	      printf("\n");
	     }
       }
{valrels} {inserer(yytext,"valeur real"); return valreal;}
{valrel} {inserer(yytext,"valeur real"); return valreal;}
{valints} {if((atoi(yytext)<=32767)&&(atoi(yytext)>=-32768)) {inserer(yytext,"valeur int");return valint; }
          else{ printf("Erreur Lexical: valeur entière erronée ---> ");ECHO;
	         printf("\n");
	       }
         }
{valint} {if((atoi(yytext)<=32767)&&(atoi(yytext)>=-32768)) {inserer(yytext,"valeur int");return valint; }
          else{ printf("Erreur Lexical: valeur entière erronée ---> ");ECHO;
	         printf("\n");
	       }
         }
{varchar} {inserer(yytext,"un caractère"); return valchar;}
{varstr} {inserer(yytext,"une chaine de caractère");return valstr; }	   
"{" {inserer(yytext,strdup(yytext)); return yytext[0];}
"}" {inserer(yytext,strdup(yytext)); return yytext[0];}
"[" {inserer(yytext,strdup(yytext));return yytext[0]; }
"]" {inserer(yytext,strdup(yytext));return yytext[0]; }
[;:,] return yytext[0] ;
"|" return yytext[0] ;
{affect} {inserer(yytext,strdup(yytext)); return affectaion;}
[ \t\n]       
. printf("erreur lexicale :entité non reconnu");
