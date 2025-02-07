all: lex.l tokens-manual.h
	flex lex.l
	gcc -o lextest lex.yy.c lextest.c

run: all
	gcc -E ltests/*.c | ./lextest >ltest.out 2>ltest.err

debug: all
	gcc -E ltests/*.c | ./lextest

clean:
	rm -f lex.yy.c lexer lextest ltest.out ltest.err