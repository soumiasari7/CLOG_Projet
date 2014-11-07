%{
int nb_ligne=1;
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
{mc} {printf("Mot Clé: ");ECHO;printf("\n");}
{oparth} {printf("Opérateur arithmétique: ");ECHO;printf("\n");}
{oplog} {printf("Opérateur logique: ");ECHO;printf("\n");}
{opcomp} {printf("Opérateur de comparaison: ");ECHO;printf("\n");}
{sdf} {printf("signe de formatage: ");ECHO;printf("\n");}
{valint} {if((atoi(yytext)<=32767)&&(atoi(yytext)>=-32768)) {printf("Valeur entière: ");ECHO;printf("\n");}
          else{ printf("Erreur Lexical: valeur entière erronée ---> ");ECHO;
	         printf("\n");
	       }
         }
{valrel} {printf("Valeur réel: ");ECHO;printf("\n");}
{varchar} {printf("Variable de type char: ");ECHO;printf("\n");}
{varstr} {printf ("Une chaine de caractère: ");ECHO;printf("\n");}
"{" {printf("Accolade:Ouvrante ");}
"}" {printf("Accolade:Fermante ");}
{idf} {if (yyleng<=8) {printf("Identificateur: ");ECHO;printf("\n");}
       else {printf("Erreur lexical:IDF trop long ---> ");ECHO;
	      printf("\n");
	     }
       }
{com} {printf("Ceci est un commentaire: ");ECHO;printf("\n");}
{cro} {printf("Des crochets: ");ECHO;printf("\n");}
{par} {printf("Des parenthèses: ");ECHO;printf("\n");}
{aro} {printf("Arobase: ");ECHO;printf("\n");}
{affect} {printf("Affectation: ");ECHO;printf("\n");}
{sep} 
\n {nb_ligne++;printf("\n");}
. {printf("Erreur lexical à la ligne %d ",nb_ligne);ECHO;printf("\n");}
