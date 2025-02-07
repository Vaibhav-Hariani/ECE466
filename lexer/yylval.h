enum numtypes {
    TYPE_I=0,
    TYPE_UI,
    TYPE_LI,
    TYPE_ULI,
    TYPE_LLI,
    TYPE_ULLI,
    TYPE_FD,
    TYPE_D,
    TYPE_LD
};

typedef union {
	long long int i;
	long double f;
} NumberValue;

typedef struct {
	NumberValue val;
	char type;
} TypedNumber;

typedef union {
	char *s;
	char c;
	TypedNumber n;
} YYSTYPE;

YYSTYPE yylval;
int line;