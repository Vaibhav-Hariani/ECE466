
tokens = ''' 
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    TOKEOF = 258,                  /* TOKEOF  */
    ELLIPSIS = 259,                /* ELLIPSIS  */
    POUNDPOUND = 260,              /* POUNDPOUND  */
    AUTO = 261,                    /* AUTO  */
    BREAK = 262,                   /* BREAK  */
    CASE = 263,                    /* CASE  */
    CHAR = 264,                    /* CHAR  */
    CONST = 265,                   /* CONST  */
    CONTINUE = 266,                /* CONTINUE  */
    DEFAULT = 267,                 /* DEFAULT  */
    DO = 268,                      /* DO  */
    DOUBLE = 269,                  /* DOUBLE  */
    ELSE = 270,                    /* ELSE  */
    ENUM = 271,                    /* ENUM  */
    EXTERN = 272,                  /* EXTERN  */
    FLOAT = 273,                   /* FLOAT  */
    FOR = 274,                     /* FOR  */
    GOTO = 275,                    /* GOTO  */
    IF = 276,                      /* IF  */
    INLINE = 277,                  /* INLINE  */
    INT = 278,                     /* INT  */
    LONG = 279,                    /* LONG  */
    REGISTER = 280,                /* REGISTER  */
    RESTRICT = 281,                /* RESTRICT  */
    RETURN = 282,                  /* RETURN  */
    SHORT = 283,                   /* SHORT  */
    SIGNED = 284,                  /* SIGNED  */
    STATIC = 285,                  /* STATIC  */
    STRUCT = 286,                  /* STRUCT  */
    SWITCH = 287,                  /* SWITCH  */
    TYPEDEF = 288,                 /* TYPEDEF  */
    UNION = 289,                   /* UNION  */
    UNSIGNED = 290,                /* UNSIGNED  */
    VOID = 291,                    /* VOID  */
    VOLATILE = 292,                /* VOLATILE  */
    WHILE = 293,                   /* WHILE  */
    BOOL = 294,                    /* BOOL  */
    COMPLEX = 295,                 /* COMPLEX  */
    IMAGINARY = 296,               /* IMAGINARY  */
    PLUSPLUS = 297,                /* "++"  */
    MINUSMINUS = 298,              /* "--"  */
    PLUSEQ = 299,                  /* PLUSEQ  */
    MINUSEQ = 300,                 /* MINUSEQ  */
    DIVEQ = 301,                   /* DIVEQ  */
    TIMESEQ = 302,                 /* TIMESEQ  */
    MODEQ = 303,                   /* MODEQ  */
    SHLEQ = 304,                   /* SHLEQ  */
    SHREQ = 305,                   /* SHREQ  */
    ANDEQ = 306,                   /* ANDEQ  */
    OREQ = 307,                    /* OREQ  */
    XOREQ = 308,                   /* XOREQ  */
    LOGAND = 309,                  /* LOGAND  */
    LOGOR = 310,                   /* LOGOR  */
    EQEQ = 311,                    /* EQEQ  */
    NOTEQ = 312,                   /* NOTEQ  */
    GTEQ = 313,                    /* GTEQ  */
    LTEQ = 314,                    /* LTEQ  */
    SHL = 315,                     /* SHL  */
    SHR = 316,                     /* SHR  */
    SIZEOF = 317,                  /* SIZEOF  */
    PREFIX = 318,                  /* PREFIX  */
    POSTFIX = 319,                 /* POSTFIX  */
    INDSEL = 320,                  /* INDSEL  */
    IDENT = 321,                   /* IDENT  */
    CHARLIT = 322,                 /* CHARLIT  */
    NUM = 323,                     /* NUM  */
    STRING = 324                   /* STRING  */
'''


if __name__ == "__main__":

    token_db = {}
    for line in tokens.splitlines():
        curline = line.strip().split(",")[0]
        curline = curline.split('=')[0]
        print("tokens[%s] = \"%s\" ;" % (curline, curline))