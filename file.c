#include "file.h"

struct file{
    char* nome;
    int size;
    int capacity;
    File* sub;
};

int isFolder(File f){
    if(f->nome[ strlen(f->nome)-1 ] == '/') return 1;
    else return 0;
}

File initFile(){
    File f = malloc(sizeof(struct file));
    f->nome = NULL;
    f->size = 0;
    f->capacity = 10;
    f->sub = malloc(f->capacity * sizeof(struct file));
    return f;
}

void push(File f, File sub){
    if( f->size <=  f->capacity){
          realloc(f->sub, sizeof(f->sub) * 2);
          f->capacity = sizeof(f->sub) * 2;
     }
     f->sub[f->size] = sub;
     f->size++;
}

void setName(File f, char* name){
    f->nome = strdup(name);
}

void freeFile(File f){
    free(f->nome);
    for(int i = 0; i < f->size ; i++)
        freeFile(f->sub[i]);

    free(f);
}

int main(){

    File f = initFile();
    File s = initFile();
    
    
    
    push(f,s);
    setName(f, "boas ");
    setName(s , "pinguins");
    s = initFile();
    char* sd = strdup(f->sub[0]->nome);
    char* eaiuf = strdup(strcat(f->nome, sd));
    printf("%s\n" , eaiuf);

    freeFile(f);
    return 0;

}





