

nome: nome.fl
	flex nome.fl
	cc -o nome lex.yy.c

install: nome
	cp nome /usr/local/bin/

