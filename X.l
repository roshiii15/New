%{
#include "y.tab.h"
%}

digit    [0-9]
id       [a-zA-Z_][a-zA-Z0-9_]*
ws       [ \t\n]

%%

"for"        { return FOR; }
"("          { return LPAREN; }
")"          { return RPAREN; }
";"          { return SEMICOLON; }
"="          { return ASSIGN; }
"<"          { return LT; }
">"          { return GT; }
"+"          { return PLUS; }
{id}         { yylval = strdup(yytext); return ID; }
{digit}+     { yylval = atoi(yytext); return NUMBER; }
{ws}+        { /* Ignore whitespace */ }
.            { /* Ignore other characters */ }

%%

int yywrap() {
    return 1;
}
