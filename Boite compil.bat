flex tampon.l
bison -d tampon.y
gcc lex.yy.c tampon.tab.c -lfl -ly -o tampon.exe
tampon.exe <test.txt >Resultat.txt
PAUSE
