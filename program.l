%{
int nb_ligne=1;
%}
chiffre0[0-9]
chiffre1[1-9]
idf [A-Z]([a-z]|{chiffre0}|_)*
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
sep[,;:| ]
cro "["|"]"
aro @
affect =
%%
{mc} {printf("Mot Clè: ");ECHO;}
{oparth} {printf("Opérateur arithmétique: ");ECHO;}
{oplog} {printf("Opérateur logique: ");ECHO;}
{opcomp} {printf("Opérateur de comparaison: ");ECHO;}
{sdf} {printf("signe de formatage: ");ECHO;}
{valint} {if((atoi(yytext)<=32767)&&(atoi(yytext)>=-32768)) {printf("Valeur entière: ");ECHO;}
else printf("Erreur Lexical: valeur entière erronée ");}
{valrel} {printf("Valeur réel: ");ECHO;}
{varchar} {printf("Variable de type char: ");ECHO;}
{varstr} {printf ("Une chaine de caractère: ");ECHO;}
"{" {printf("Accolade:Ouvrante ");}
"}" {printf("Accolade:Fermante ");}
{idf} {if (yyleng<=8) {printf("Idantifiateur: ");ECHO;}
       else printf("Erreur lexical:IDF trop long ");
       }
{com} {printf("Ceci est un commentaire: ");ECHO:}
{cro} {printf("des crochets: ");ECHO;}
{aro} {printf("arobase: ");ECHO;}
{affect} {printf("affectation: ");ECHO;}
{sep} 
\n {nb_ligne++;printf("\n");}
. {printf("Erreur lexical à la ligne %d",nb_ligne);ECHO;}
