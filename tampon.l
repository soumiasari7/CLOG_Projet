%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tampon.tab.h"
int nb_ligne=1; 

/*====déclaration d'une structure de donnée pour la table de symbole====*/
typedef struct
{
char NomEntite[30];
char CodeEntite[30];
char TypeEntite[30];
int ValEntite;
} TypeTS;

/*===initiation d'un tableau qui va contenir les elements de la table de symbole==*/
TypeTS ts[200]; 

/*===un compteur global pour la table de symbole===*/
int CpTabSym=0;


/*==une fonctione recherche: pour chercher est ce que l'entité existe ou non déjà dans la table de symbole.==*
/*==== i: l'entite existe dejà dans la table de symbole, et sa position est i, -1: l'entité n'existe pas dans la table de symbole.====*/

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

/*========une fontion qui va insérer les entités de programme dans la table de symbole=======*/
void inserer(char entite[], char code[])
{
if ( recherche(entite)==-1)
{
strcpy(ts[CpTabSym].NomEntite,entite); 
strcpy(ts[CpTabSym].CodeEntite,code);
//printf("lentite est %s, sont type est %s %d\n",ts[CpTabSym].NomEntite,ts[CpTabSym].TypeEntite,CpTabSym);
CpTabSym++;
}
}

/*================une fonction pour afficher la table de symbole==============*/
void afficher ()
{
printf("\n                                 /*==============================================================*/\n");
printf("                                /********************Table des symboles *************************/\n");
printf("                               /*==============================================================*/\n");
printf("\t_________________________________________________________________________________________________________________________\n");
printf("\t|          NomEntite        |         CodeEntite           |         TypeEntite           |          ValeurEntite       |\n");
printf("\t_________________________________________________________________________________________________________________________\n");
int i=0;
while(i<CpTabSym)
{
if ((strcmp(ts[i].TypeEntite,"")==0)&&(strcmp(ts[i].CodeEntite,"idf")!=0))
{
printf("\t|%26s |%28s  |%27s   |---------------------------- |\n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite);
}
else
{
printf("\t|%26s |%28s  |%27s   | %5d\t|\n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite,ts[i].ValEntite);
 }
i++;
}
printf("\t_________________________________________________________________________________________________________________________\n");
}

// fonction qui change le type d'une etité une fois il va être reconu dans la syntaxe 

void insererType(char entite[], char type[])
{

int posEntite=recherche(entite);
if (posEntite!=-1)
{ 

strcpy(ts[posEntite].TypeEntite,type);

//printf("lentite est %s, sont type est %s %d\n",ts[CpTabSym].NomEntite,ts[CpTabSym].TypeEntite,CpTabSym);

}
}

//insérer la valeur d'une entité dans la table de symbole
void insereVal(char entite[], int val)
{
int posEntite=recherche(entite);
if (posEntite!=-1)
{ 
ts[posEntite].ValEntite=val;
}
}

//retourner la valeur d'une entité
int retournerVal(char entite[])
{
int posEntite=recherche(entite);

//printf ("\nfunction %s %d\n",ts[posEntite].NomEntite,ts[posEntite].ValEntite );

return ts[posEntite].ValEntite;
}
%}
/*==========================================================Partie Règle ======================================================================*/  
chiffre0[0-9]
chiffre1 [1-9]
valint ({chiffre1}{chiffre0}*|0)
valints "(-"({chiffre1}{chiffre0}*)")"
valrel ({chiffre1}{chiffre0}*|0)"."({chiffre0}*)
valrels "(-"({chiffre1}{chiffre0}*|0)"."({chiffre0}*)")"
varchar '.'
varstr \"(.)*\"
affect =
idf [A-Z]([a-z]|{chiffre0})*
oparth [-+*/]

%%
G {inserer(yytext,"mc_G"); return mc_G;}
L {inserer(yytext,"mc_L"); return mc_L;}
GE {inserer(yytext,"mc_GE"); return mc_GE;}
LE {inserer(yytext,"mc_LE"); return mc_LE;}
EQ {inserer(yytext,"mc_EQ"); return mc_EQ;}
DI {inserer(yytext,"mc_DI"); return mc_DI;}
AND {inserer(yytext,"mc_AND"); return mc_AND;}
OR {inserer(yytext,"mc_OR"); return mc_OR;}
NOT {inserer(yytext,"mc_NOT"); return mc_NOT;}
IF {inserer(yytext,"mc_IF"); return mc_IF;}
ELSE {inserer(yytext,"mc_ELSE"); return mc_ELSE;}
END {inserer(yytext,"mc_END"); return mc_END;}
INTEGER {inserer(yytext,"mc_INTEGER"); return mc_INTEGER; }
FLOAT {inserer(yytext,"mc_FLOAT"); return mc_FLOAT;}
CHAR {inserer(yytext,"mc_CHAR"); return mc_CHAR;}
STRING {inserer(yytext,"mc_STRING"); return mc_STRING;}
VECTOR {inserer(yytext,"mc_VECTOR"); return mc_VECTOR;}
CONST {inserer(yytext,"mc_CONST"); return mc_CONST;}
READ {inserer(yytext,"mc_READ"); return mc_READ;}
DISPLAY {inserer(yytext,"mc_DISPLAY"); return mc_DISPLAY;}
FOR {inserer(yytext,"mc_FOR"); return mc_FOR;}


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
\"\$\" {inserer(yytext,strdup(yytext)); return dollar; }
\"#\" {inserer(yytext,strdup(yytext));return dieze;}	 
\"&\" {inserer(yytext,strdup(yytext));return ecom;}	 
\"%\" {inserer(yytext,strdup(yytext));return prcent;}	 
{varchar} {inserer(yytext,"un caractère"); return valchar;}
{varstr} {inserer(yytext,"une chaine de caractère");return valstr; }	   
"{" {inserer(yytext,strdup(yytext)); return yytext[0];}
"}" {inserer(yytext,strdup(yytext)); return yytext[0];}
"[" {inserer(yytext,strdup(yytext));return yytext[0]; }
"]" {inserer(yytext,strdup(yytext));return yytext[0]; }
"(" {inserer(yytext,strdup(yytext));return yytext[0]; }
")" {inserer(yytext,strdup(yytext));return yytext[0]; }
{oparth} {inserer(yytext,strdup(yytext)); return yytext[0];}
[;:,] return yytext[0] ;
"|" return yytext[0] ;
"@" return yytext[0] ;
"\"" return yytext[0] ;
{affect} {inserer(yytext,strdup(yytext)); return affectaion;}
[ \t\n]       
. printf("erreur lexicale :entité non reconnu");
