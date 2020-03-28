

ric.fl.md: ric.fl.md.fl
	flex ric.fl.md.fl
	cc -o ric.fl.md lex.yy.c

install: ric.fl.md
	cp ric.fl.md /usr/local/bin/

