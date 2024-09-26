%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();

typedef struct treeNode {
    char *token;
    struct treeNode *left;
    struct treeNode *right;
} treeNode;

treeNode* createNode(char *token, treeNode *left, treeNode *right);
void printParseTree(treeNode *node, int level);

%}

%union {
    int number;
    char *id;
    struct treeNode *node;
}

/* Declare tokens */
%token <id> ID
%token <number> NUMBER
%token FOR LPAREN RPAREN SEMICOLON ASSIGN LT GT PLUS

/* Operator precedence and associativity */
%left LT GT
%left PLUS

%type <node> expr stmt for_loop assign_stmt condition

%%

program: 
    stmt { printParseTree($1, 0); }
    ;

stmt: 
    for_loop 
    ;

for_loop:
    FOR LPAREN assign_stmt SEMICOLON condition SEMICOLON assign_stmt RPAREN 
    {
        $$ = createNode("for", $3, createNode("condition", $5, $7));
    }
    ;

assign_stmt:
    ID ASSIGN expr 
    {
        char buffer[100];
        sprintf(buffer, "%s = ", $1);
        $$ = createNode(buffer, $3, NULL);
    }
    ;

condition:
    expr LT expr 
    {
        $$ = createNode("<", $1, $3);
    }
    | expr GT expr 
    {
        $$ = createNode(">", $1, $3);
    }
    ;

expr:
    expr PLUS expr 
    {
        $$ = createNode("+", $1, $3);
    }
    | NUMBER 
    {
        char buffer[100];
        sprintf(buffer, "%d", $1);
        $$ = createNode(buffer, NULL, NULL);
    }
    | ID 
    {
        $$ = createNode($1, NULL, NULL);
    }
    ;

%%

treeNode* createNode(char *token, treeNode *left, treeNode *right) {
    treeNode *node = (treeNode*) malloc(sizeof(treeNode));
    node->token = strdup(token);
    node->left = left;
    node->right = right;
    return node;
}

void printParseTree(treeNode *node, int level) {
    if (node == NULL) return;

    for (int i = 0; i < level; i++) {
        printf("  ");
    }
    printf("%s\n", node->token);

    printParseTree(node->left, level + 1);
    printParseTree(node->right, level + 1);
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}
