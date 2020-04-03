%{
#include <stdio.h>
#include <string.h>
#include "tree.h"

char* name;
Tree fol;
char* author, * email;
char* treename;
char* make = "", *readme = "", *flStr = "";
char* mdStr = "";
Tree subfol;
Tree tree;
int countHifen(char* nome);
char* noHifen(char* nome);

%}

%s META TREE FILES
%option noyywrap
%%
    
    BEGIN 0; 

  

<*>===[ ]meta { BEGIN META; }

<*>===[ ]tree { BEGIN TREE; }

<*>===[ ].* { 
            BEGIN FILES; 
            tree = NULL;
            char* ficheiro;
            char* token = strtok(yytext, "."); 
            char* ponto, *treename = "";
            int i = 0;
            while (token != NULL) { 
              ponto = strdup(token);
              token = strtok(NULL, "."); 
              if(token!=NULL) treename=myCat(treename,ponto);
              i++;
            }
            if(!strcmp(treename+4 , "{%name%}")) ficheiro= strdup( myCat(name, myCat(".", ponto)));
            else if (i > 1) ficheiro = myCat(yytext+4, myCat(".", ponto));
            else ficheiro = strdup(yytext+4);
            tree = search(fol,ficheiro);
          }


<META>email:[ ].+ {email = strdup(yytext+7);}
<META>author:[ ].+ {author = strdup(yytext+8);}


<TREE>[-]*[ ]*[a-zA-Z\{\}\%]+\/ {
                      Tree sube = fol;
                      for(int i = 0 ; i < countHifen(yytext) ; i++){
                        sube = getSub(sube,getTamanho(sube)-1);
                      }
                      subfol=initTree();
                      if(!strcmp(noHifen(yytext), "{%name%}/")) setName(subfol, myCat(name,"/"));
                      else setName(subfol, noHifen(yytext));
                      push(sube, subfol);
                    }


<TREE>[-]*[ ]*[.a-zA-Z\{\}\%]+ {
                        Tree sube = fol;
                        
                        for(int i = 0 ; i < countHifen(yytext) ; i++){
                          sube = getSub(sube,getTamanho(sube)-1);
                        }
                        tree=initTree();
                        char* token = strtok(yytext, "."); 
                        char* ponto, *treename = "";
                        int i = 0;
                        while (token != NULL) { 
                          ponto = strdup(token);
                          token = strtok(NULL, "."); 
                          if(token!=NULL) treename=myCat(treename,ponto);
                          i++;
                        }
                        if(!strcmp(noHifen(treename), "{%name%}")) setName(tree, myCat(name, myCat(".", ponto)));
                        else if (i > 1) setName(tree, myCat(noHifen(yytext), myCat(".", ponto)));
                        else setName(tree, noHifen(yytext));
                        push(sube, tree);
                      }


<FILES>\{\%author\%\} { setText(tree, myCat(getText(tree), author) ); }
<FILES>\{\%email\%\} { setText(tree, myCat(getText(tree), email) ); }
<FILES>\{\%name\%\} { setText(tree, myCat(getText(tree), name) ); }
<FILES>.|\n { setText(tree, myCat(getText(tree), yytext) );}


[ \t\n\r] ;

.|\n ;


%%

char* noHifen(char* nome){
  int i;

  for(i = 0 ; i < strlen(nome)-1 ; i++)
    if(nome[i] != '-') break;
  if(i == 0) return nome;
  return nome+i+1;
}

int countHifen(char* nome){

  int i;

  for(i = 0 ; i < strlen(nome)-1 ; i++)
    if(nome[i] != '-') break;

  return i;
}

int main(int argc, char** argv){
  fol=initTree();
  setName(fol,"{%name%}");
  name = strdup(argv[1]);
  yyin = fopen(argv[2],"r");
  yylex();
  create(fol);
  freeTree(fol);

  return 0;
}