%{
#include <stdio.h>
#include <string.h>
#include "file.h"

char* name, *namefol;
File fol;
char* author, * email;
char* filename;
char* make = "", *readme = "", *flStr = "";
char* mdStr = "";
File subfol;
File file;

char* myCat (char* original, char* apendice){
  char* new_str;
  if((new_str = malloc(strlen(original)+strlen(apendice)+1)) != NULL){
    new_str[0] = '\0';
    strcat(new_str,original);
    strcat(new_str,apendice);
  } 
  return new_str;
}

void mkMakeFile(char* str){
    FILE* mk;
    mk = fopen("Makefile", "w");
    for (int i = 0; str[i] != '\0'; i++) {
            fputc(str[i], mk);
        }
    fclose(mk);
}

void mkMD(char* str){
    FILE* md;
    char* file_name = "";
    file_name = myCat (file_name, name);
    file_name = myCat (file_name, ".md");
    md = fopen(file_name, "w");
    for (int i = 0; str[i] != '\0'; i++) {
            fputc(str[i], md);
        }
    fclose(md);
}

void mkFL(char* str){
    FILE* fl;
    char* file_name = "";
    file_name = myCat (file_name, name);
    file_name = myCat (file_name, ".fl");
    fl = fopen(file_name, "w");
    for (int i = 0; str[i] != '\0'; i++) {
            fputc(str[i], fl);
        }
    fclose(fl);
}

void mkREADME(char* str){
    FILE* readme;
    char* file_name = "README.md";
    readme = fopen(file_name, "w");
    for (int i = 0; str[i] != '\0'; i++) {
            fputc(str[i], readme);
        }
    fclose(readme);
}


%}

%s META TREE MAKEFILE MD FL README NAME
%option noyywrap
%%
    
    BEGIN 0; 

  

<*>===[ ]meta { BEGIN META; }

<*>===[ ]tree { BEGIN TREE; }

<*>===[ ]Makefile { BEGIN MAKEFILE;}

<*>===[ ]\{\%name\%\}\.md { BEGIN MD; }

<*>===[ ]\{\%name\%\}\.fl { BEGIN FL; }

<*>===[ ]README { BEGIN README; }

<META>email:[ ].+ {email = strdup(yytext+7);}
<META>author:[ ].+ {author = strdup(yytext+8);}


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

<TREE>\-[ ][.a-zA-Z\{\}\%]+ {
                        file=initFile();
                        char* token = strtok(yytext, "."); 
                        char* ponto, *filename = "";
                        int i = 0;
   
                        while (token != NULL) { 
                          ponto = strdup(token);
                          printf("%s\n", token);
                          token = strtok(NULL, "."); 
                          if(token!=NULL) filename=myCat(filename,ponto);
                          i++;
                        }
                        printf("%s\n", filename);
                        if(!strcmp(filename+2, "{%name%}")) setName(file, myCat(name, myCat(".", ponto)));
                        else setName(file, yytext+2);
                        push(fol, file);
                      }



<TREE>\-\-[ ][.a-zA-Z\{\}\%]+ {
                        file=initFile();
                        char* token = strtok(yytext, "."); 
                        char* ponto, *filename = "";
                        int i = 0;
   
                        while (token != NULL) { 
                          ponto = strdup(token);
                          printf("%s\n", token);
                          token = strtok(NULL, "."); 
                          if(token!=NULL) filename=myCat(filename,ponto);
                          i++;
                        }
                        printf("%s\n", filename);
                        if(!strcmp(filename+3, "{%name%}")) setName(file, myCat(name, myCat(".", ponto)));
                        else setName(file, yytext+3);
                        push(subfol, file);
                      }

<TREE>\-[ ][a-zA-Z\{\}\%]+\.fl {
                        file=initFile();
                        if(!strcmp(yytext+2, "{%name%}.fl")) setName(file, myCat(name, ".fl"));
                        else setName(file, yytext+2);
                        push(fol, file);
                      }

<TREE>\-\-[ ][a-zA-Z\{\}\%]+\.fl {
                        file=initFile();
                        if(!strcmp(yytext+3, "{%name%}.fl")) setName(file, myCat(name, ".fl"));
                        else setName(file, yytext+2);
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


<MAKEFILE>\{\%name\%\} { make=myCat(make,name); }
<MAKEFILE>.|\n { make=myCat(make,yytext); }



<MD>\{\%name\%\} { mdStr=myCat(mdStr, name); }
<MD>\{\%author\%\} { mdStr=myCat(mdStr, author); }
<MD>\{\%email\%\} { mdStr=myCat(mdStr, email); }
<MD>.|\n { mdStr=myCat(mdStr, yytext); }


<FL>.|\n { flStr=myCat(flStr, yytext); }

<README>.*[\n]* { readme=myCat(readme, yytext); }

[ \t\n\r] ;

<META,TREE,MAKEFILE,FL,NAME>\#.* ;


%%



int main(int argc, char** argv){
  name = strdup(argv[1]);
  namefol = strdup(argv[1]);
  strcat(namefol , "/");
  yylex();
  mkMakeFile(make);
  mkMD(mdStr);
  mkFL(flStr);
  mkREADME(readme);

  printf("%s\n", getName(getSub(fol,4)));

  freeFile(fol);


  return 0;
}