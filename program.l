%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
chiffre1[1-9]
idf [A-Z]([a-z]|{chiffre0})*
mc INTEGER|FLOAT|CHAR|STR|CONST|VECTOR|READ|DISPLAY|IF|ELSE|END|FOR
valint "("?"-"?({chiffre1}{chiffre0}*|0)")"?
valrel [(]?[+-]?({chiffre1}{chiffre0}*|0)"."({chiffre0}*)")"?
varchar '.'
varstr \"(.)*\"
com "//"(.)*
oparth [-+*/]
oplog AND|OR|NOT
opcomp G|L|GE|LE|EQ|DI
sdf[$%#&]
sep[\t,;:| ]
cro "["|"]"
par "("|")"
aro @
affect =
%%
{mc} { char code[20]="mc_"; strcat(code,yytext);
inserer(yytext,code);
}
{oparth} {inserer(yytext,strdup(yytext)); }
{oplog} {inserer(yytext,strdup(yytext)); }
{opcomp} {inserer(yytext,strdup(yytext)); }
{sdf} {inserer(yytext,strdup(yytext)); }
{valint} {if((atoi(yytext)<=32767)&&(atoi(yytext)>=-32768)) {inserer(yytext,"valeur int"); }
          else{ printf("Erreur Lexical: valeur entière erronée ---> ");ECHO;
	         printf("\n");
	       }
         }
{valrel} {inserer(yytext,"valeur real"); }
{varchar} {inserer(yytext,"un caractère"); }
{varstr} {inserer(yytext,"une chaine de caractère"); }
"{" {inserer(yytext,strdup(yytext)); }
"}" {inserer(yytext,strdup(yytext)); }
{idf} {if (yyleng<=8) {inserer(yytext,"IDF"); }
       else {printf("Erreur lexical:IDF trop long ---> ");ECHO;
	      printf("\n");
	     }
       }
{com} {inserer(yytext,"un commentaire"); }
{cro} {inserer(yytext,strdup(yytext)); }
{par} {inserer(yytext,strdup(yytext)); }
{aro} {inserer(yytext,strdup(yytext)); }
{affect} {inserer(yytext,strdup(yytext)); }
{sep} 
\n {nb_ligne++;printf("\n");}
. {printf("Erreur lexical à la ligne %d ",nb_ligne);ECHO;printf("\n");}

%%
// apelle a la fonction afficher
main ()
{
yylex();
afficher();
}
