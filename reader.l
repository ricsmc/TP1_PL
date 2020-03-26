%{
#include <stdio.h>
#include <string.h>
%}
%s META TREE MAKEFILE MD FL README
%option noyywrap
%%
    char* author, * email;
    BEGIN 0;   

[ \t\n\r] ;
===[ ]meta { BEGIN META; }
<META>email:[ ].+ {email = strdup(yytext+7);}
<META>author:[ ].+ {author = strdup(yytext+8);}

===[ ]tree { BEGIN TREE; }

===[ ]Makefile { BEGIN MAKEFILE; }

===[ ]\{\%name\%\}\.md { BEGIN MD; }

===[ ]\{\%name\%\}\.fl { BEGIN FL; }

===[ ]README { BEGIN README; }

%%

int main(){
  yylex();
  return 0;
}