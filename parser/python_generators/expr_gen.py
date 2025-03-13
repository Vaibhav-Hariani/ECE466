tokens = ''' 
";"				{return(';');}

"+"				{return('+');}
"-"				{return('-');}
"*"				{return('*');}
"/"				{return('/');}
"%"				{return('%');}
">"				{return('>');}
"<"				{return('<');}
"="				{return('=');}

"."				{return('.');}
","				{return(',');}

":"				{return(':');}
"?"				{return('?');}
"&"				{return('&');}
"|"				{return('|');}
"!"				{return('!');}
"^"				{return('^');}
"~"				{return('~');}

"("				{return('(');}
")"				{return(')');}
"["				{return('[');}
"]"				{return(']');}
"{"				{return('{');}
"}"				{return('}');}

"<:"			{return('[');}
":>"			{return(']');}
"<%"			{return('{');}
"%>"			{return('}');}
"%:"			{return('#');}
"%:%:"			{return(POUNDPOUND);}

"->"			{return(INDSEL);}
"++"			{return(PLUSPLUS);}
"--"			{return(MINUSMINUS);}
"<<"			{return(SHL);}
">>"			{return(SHR);}
"<="			{return(LTEQ);}
">="			{return(GTEQ);}
"=="			{return(EQEQ);}
"!="			{return(NOTEQ);}
"&&"			{return(LOGAND);}
"||"			{return(LOGOR);}
"..."			{return(ELLIPSIS);}
"*="			{return(TIMESEQ);}
"/="			{return(DIVEQ);}
"%="			{return(MODEQ);}
"+="			{return(PLUSEQ);}
"-="			{return(MINUSEQ);}
"<<="			{return(SHLEQ);}
">>="			{return(SHREQ);}
"&="			{return(ANDEQ);}
"|="			{return(OREQ);}
"^="			{return(XOREQ);}
"##"			{return(POUNDPOUND);}
'''


if __name__ == "__main__":
    import re
    value_start = len('''"{return( ''') - 2
    value_end = len(''');}"''') -1
    token_db = {}
    for line in tokens.splitlines():
        line_arr = line.split("\t")
        if(len(line_arr) > 1):
            key = re.sub(r'''['"]''', '', line_arr[0])
            value = line_arr[-1][value_start:-value_end]
            value = re.sub(r'''['"]''', '', value)
            token_db[key] = value
    for key in token_db:
        val = token_db[key]
        if(len(val) == 1):
            val = "'" + val + "'"
        print("|\t expr %s expr \t { $$=new_ast_node(AST_binop, $1, $3, %s);}" % (val, val)) 
        # print(val, end = ' ')
    print ('\n \n')
    # for token in token_db:
    #     print(token, end = ' ')
