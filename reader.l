%{
#include <stdio.h>
#include <string.h>
#include "file.h"

char* name, *namefol;
File fol;

%}

%s META TREE MAKEFILE MD FL README
%option noyywrap
%%
    char* author, * email;
    char* filename;
    File subfol;
    File file;
    BEGIN 0; 

  

[ \t\n\r] ;
===[ ]meta { BEGIN META; }
<META>email:[ ].+ {email = strdup(yytext+7);}
<META>author:[ ].+ {author = strdup(yytext+8);}

\#.+ ;
===[ ]tree { BEGIN TREE; }

<TREE>[a-zA-Z\{\}\%]+\/ {   
  
                    fol=initFile(); 
                    if(!strcmp(yytext, "{%name%}/")) setName(fol, namefol);
                    else setName(fol, yytext);
                   }

<TREE>\-[ ][a-zA-Z\{\}\%]+\/ {
                      subfol=initFile();
                      if(!strcmp(yytext+2, "{%name%}/")) setName(subfol, namefol);
                      else setName(subfol, yytext+2);
                      push(fol, subfol);
                    }

<TREE>\-[ ][a-zA-Z\{\}\%]+\.md {
                        file=initFile();
                        if(!strcmp(yytext+2, "{%name%}.md")) setName(file, strcat(name, ".md"));
                        else setName(file, yytext+2);
                        push(fol, file);
                      }

<TREE>\-\-[ ][a-zA-Z\{\}\%]+\.md {
                        file=initFile();
                        if(!strcmp(yytext+3, "{%name%}.md")) setName(file, strcat(name, ".md"));
                        else setName(file, yytext+2);
                        push(subfol, file);
                      }   

<TREE>\-[ ][a-zA-Z\{\}\%]+\.fl {
                        file=initFile();
                        if(!strcmp(yytext+2, "{%name%}.fl")) setName(file, strcat(name, ".fl"));
                        else setName(file, yytext+2);
                        push(fol, file);
                      }

<TREE>\-\-[ ][a-zA-Z\{\}\%]+\.fl {
                        file=initFile();
                        if(!strcmp(yytext+3, "{%name%}.fl")) setName(file, strcat(name, ".fl"));
                        else setName(file, yytext+2);
                        push(subfol, file);
                      }                     


<TREE>\-[ ]README {
                      file=initFile();
                      setName(file, "README");
                      push(fol, file);
                    }

<TREE>\-\-[ ]README {
                      file=initFile();
                      setName(file, "README");
                      push(subfol, file);
                    }


<TREE>\-[ ]Makefile { 
                      file=initFile();
                      setName(file, "Makefile");
                      push(fol, file);
                    }

<TREE>\-\-[ ]Makefile {
                      file=initFile();
                      setName(file, "Makefile");
                      push(subfol, file);
                    }



===[ ]Makefile { BEGIN MAKEFILE; }

===[ ]\{\%name\%\}\.md { BEGIN MD; }

===[ ]\{\%name\%\}\.fl { BEGIN FL; }

===[ ]README { BEGIN README; }

%%

int main(int argc, char** argv){
  name = strdup(argv[1]);
  namefol = strdup(argv[1]);
  strcat(namefol , "/");

  yylex();

  File oi = getSub(fol,3);
  char* bruh = strdup(getName(oi));
  printf("\n%s\n", bruh);


  freeFile(fol);



  return 0;
}