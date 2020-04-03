#include "tree.h"

struct tree{
    char* nome;
    char* text;
    int size;
    int capacity;
    Tree* sub;
};


void setName(Tree f, char* name){
    f->nome = strdup(name);
}

char* getName(Tree f){
    return f->nome;
}

int getTamanho(Tree f){
    return (f->size / sizeof(struct  tree));
}


Tree getSub(Tree f, int pos){
    return f->sub[pos];
}

void setText(Tree f, char* texto){
    f->text = strdup(texto);
}


char* getText(Tree f){
    return f->text;
}

char* getTreeName(Tree f){
    char* path = strdup(getName(f));
    char* token = strtok(path, "/"); 
    char* nome;
    int i = 0;
   
    while (token != NULL) { 
        nome = strdup(token);
        token = strtok(NULL, "/"); 
    }

    return nome;
}


char* myCat (char* original, char* apendice){
  char* new_str;
  if((new_str = malloc(strlen(original)+strlen(apendice)+1)) != NULL){
    new_str[0] = '\0';
    strcat(new_str,original);
    strcat(new_str,apendice);
  } 
  return new_str;
}

int isFolder(Tree f){
    if(f->nome[strlen(f->nome)-1]=='/') return 1;

    else return 0;
}


Tree search(Tree f, char* name){
    char * bruh = strdup(getTreeName(f));
    if(!strcmp(name, bruh)) {return f;}
    else {

        Tree aux = NULL;
        for (int i = 0; i < f->size/(sizeof(struct tree)); i++)
        {   
            aux = search(f->sub[i], name);
            if(aux != NULL) break;
            
        }
        return aux;
        
    }
}


Tree initTree(){
    Tree f = malloc(sizeof(struct tree));
    f->nome = "" ;
    f->text = "";
    f->size = 0;
    f->capacity = 10 * sizeof(struct tree);
    f->sub = malloc(10 * sizeof(struct tree));

    return f;
}

void push(Tree f, Tree sub){
    if(strcmp("{%name%}", f->nome)) setName(sub, myCat(getName(f),getName(sub))); 
    if( f->size >=  f->capacity){
          int* ignore = (int*) realloc(f->sub, f->capacity * 2);
          f->capacity = f->capacity * 2;
     }
     f->sub[f->size / sizeof(struct tree)] = sub;
     f->size+=sizeof(struct tree);
}

void freeTree(Tree f){
    if(f == NULL) return;
    free(f->nome);
    for(int i = 0; i < (f->size) / (sizeof(struct tree)) ; i++)
        freeTree(f->sub[i]);
    
    free(f->sub);
    free(f);

}

void create_folder(char* diretoria) {
   int ok = mkdir(diretoria, 0700);
   if (ok) exit(1);

}

void mkFL(Tree f){
    FILE* fl;
    char * tree_name = getName(f);
    char* str = getText(f);
    fl = fopen(tree_name, "w");
    for (int i = 0; str[i] != '\0'; i++) {
            fputc(str[i], fl);
        }
    fclose(fl);
}

 void create(Tree f){
            
     if(isFolder(f) || !strcmp("{%name%}", f->nome) ) {
         
        if(strcmp("{%name%}", f->nome)) create_folder(f->nome);
        for(int i = 0; i < (f->size) / (sizeof(struct tree)) ; i++)
            create(f->sub[i]);
     }
     else mkFL(f);
 }






