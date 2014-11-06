%{
int nb_ligne=1;
%}
chiffre0[0-9]
chiffre1[1-9]
lettre[a-zA-Z]
idf {lettre}({lettre}|{chiffre0}|_)*
type INTEGER|FLOAT|CHAR|STR|CONST|VECTOR
valint "-"?."("?({chiffre1}{chiffre0}*|0)")"?
valrel "+|-"?."("?.({chiffre1}{chiffre0}*|0)"."{chiffre0}*{chiffre1}")"?
varchar '.'
varstr \"(.)*\"
com (.)*"//"(.)*
oparth [-+*/]
oplog AND|OR|NOT
opcomp G|L|GE|LE|EQ|DI
sep[;:]
%%
{type} {printf("type:");ECHO;}
{oparth} {printf("Opérateur arithmétique: ");ECHO;}
{oplog} {printf("Opérateur logique: ");ECHO;}
{opcomp} {printf("Opérateur de comparaison: ");ECHO;}
{valint} {if((atoi(yytext)<=32767)&&(atoi(yytext)>=-32768)) {printf("Valeur entière:");ECHO;}
else printf("Erreur Lexical: valeur entière erronée");}
{valrel} {printf("Valeur réel");ECHO;}
{varchar} {printf("Variable de type char: ");ECHO;}
{varstr} {printf ("Une chaine de caractère: ");ECHO;}
"{" {printf("Accolade:Ouvrante ");}
"}" {printf("Accolade:Fermante ");}
{idf} {if (yyleng<=8) {printf("variable :");ECHO;}
       else printf("Erreur lexical:IDF trop long");
       }
{com} {printf("Ceci est un commentaire ");}       
{sep} 
\n {nb_ligne++;printf("\n");}
. {printf("Erreur lexical à la ligne %d",nb_ligne);ECHO;}

