%token idf '{' '}'
%%
program : idf 
          {
		       {}
			     {}
	        } 
		    ;
%%
main()
{
yyparse();
}
