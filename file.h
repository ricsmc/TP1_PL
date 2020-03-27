#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct file* File;

int isFolder(File f);
File initFile();
void freeFile(File f);
void setName(File f, char* name);
char* getName(File f);
File getSub(File f, int pos);
void push(File f, File sub);
