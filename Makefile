reader.exe : lex.yy.o
	gcc -o reader.exe lex.yy.o tree.o -ll

lex.yy.o tree.o: lex.yy.c tree.c
	gcc  -c lex.yy.c
	gcc -c tree.c

lex.yy.c : reader.l
	flex reader.l
