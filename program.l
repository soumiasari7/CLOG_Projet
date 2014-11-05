%{
int nb_ligne=0;
%}
chiffre[0-9]
lettre[a-zA-Z]
idf {lettre}({lettre}|{chiffre}|_)*
sep[:;]
%%
INTEGER {printf("type:INTEGER");}
CHAR {printf("type:CHAR");}
STR {printf("type:STR");}
FLOAT {printf("type:FLOAT");}
CONST {printf("type:CONST");}
"{" {printf("Accolade:Ouvrante ");}
"}" {printf("Accolade:Fermante ");}
{idf} {if (yyleng<=8) {printf("variable :");ECHO;}
      else printf("Erreur lexical:IDF trop long");
      }
{sep}
\n {nb_ligne++;printf("\n");}
. {printf("Erreur lexical à la ligne %d",nb_ligne);ECHO;}

