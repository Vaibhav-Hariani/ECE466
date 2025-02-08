all: lex.l tokens-manual.h
	flex lex.l
	gcc -o lextest -Wno-abi lex.yy.c lextest.c

run: all
	gcc -E ltests/*.c | ./lextest >ltest.out 2>ltest.err

debug: run
	-diff ltest.out ltests/ltest.out.txt
	-diff ltest.err ltests/ltest.err.txt

clean:
	rm -f lex.yy.c lexer lextest ltest.out ltest.err