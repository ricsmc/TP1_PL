#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>

typedef struct tree* Tree;

void setName(Tree f, char* name);
char* getName(Tree f);
int getTamanho(Tree f);
Tree getSub(Tree f, int pos);
void setText(Tree f, char* texto);
char* getText(Tree f);
char* getTreeName(Tree f);

char* myCat (char* original, char* apendice);
int isFolder(Tree f);
Tree initTree();
Tree search(Tree f, char* name);
void push(Tree f, Tree sub);
void freeTree(Tree f);
void create_folder(char* diretoria);
void create(Tree f);