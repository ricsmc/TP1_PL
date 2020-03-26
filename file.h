#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct file* File;

int isFolder(File f);
File initFile();
void setName(File f, char* name);
void push(File f, File sub);
