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
    f->nome = NULL ;
    f->size = 0;
    f->capacity = 10 * sizeof(struct file);
    f->sub = malloc(10 * sizeof(struct file));

    return f;
}

void push(File f, File sub){
    if( f->size >=  f->capacity){
          int* ignore = (int*) realloc(f->sub, f->capacity * 2);
          f->capacity = f->capacity * 2;
     }
     f->sub[f->size / sizeof(struct file)] = sub;
     f->size+=sizeof(struct file);
}

void setName(File f, char* name){
    f->nome = strdup(name);
}

char* getName(File f){
    return f->nome;
}

File getSub(File f, int pos){
    printf("%p\n", f->sub[pos]);
    return f->sub[pos];
}

void freeFile(File f){
    if(f == NULL) return;
    free(f->nome);
    for(int i = 0; i < (f->size) / (sizeof(struct file)) ; i++)
        freeFile(f->sub[i]);
    
    free(f->sub);
    free(f);

}

/*
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
*/





