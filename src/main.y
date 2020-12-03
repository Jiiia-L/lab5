%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}
%token T_CHAR T_INT T_STRING T_BOOL VOID

%token LOP_ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN

%token S_IF S_WHILE S_RETURN S_FOR

%token LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA

%token OR AND EQUAL NEQ GT LT GEQ LEQ ADD SUB MUL DIV MOD NOT LAND 

%token TRUE FALSE

%token IDENTIFIER INTEGER CHAR BOOL STRING

%token PRINTF SCANF MAIN

%right LOP_ASSIGN
%left OR
%left AND
%left EQUAL NEQ
%left GT LT GEQ LEQ
%left ADD SUB
%left MUL DIV MOD
%right NOT 
%right UMINUS UPLUS LAND
%left MADD MSUB


%%

program
: statements {root = new TreeNode(0, NODE_PROG); root->addChild($1);};

statements
:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
|  LBRACE statements RBRACE {$$=$2;}
;

statement
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| declaration SEMICOLON {$$ = $1;}
| assign SEMICOLON {$$=$1;}
| if {$$=$1;}
| while {$$=$1;}
| for {$$=$1;}
| return SEMICOLON {$$=$1;}
| printf SEMICOLON {$$=$1;}
| scanf SEMICOLON {$$=$1;}
| main {$$=$1;}
;

declaration
: T IDENTIFIER LOP_ASSIGN expr{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    node->addChild($4);
    $$ = node;   
} 
| T idlist {
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_DECL;
    node->addChild($1);
    node->addChild($2);
    $$ = node;   
}
;

idlist
: IDENTIFIER COMMA idlist {$1->addSibling($3); $$=$1;}
| IDENTIFIER {$$ = $1;}
;

assign
: IDENTIFIER LOP_ASSIGN expr{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_ASSIGN;
    node->addChild($1);
    node->addChild($3);
    $$ = node;   
} 
|IDENTIFIER ADD_ASSIGN expr{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_ASSIGN_ADD;
    node->addChild($1);
    node->addChild($3);
    $$ = node;   
} 
|IDENTIFIER SUB_ASSIGN expr{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_ASSIGN_SUB;
    node->addChild($1);
    node->addChild($3);
    $$ = node;   
} 
|IDENTIFIER MUL_ASSIGN expr{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_ASSIGN_MUL;
    node->addChild($1);
    node->addChild($3);
    $$ = node;   
} 
|IDENTIFIER DIV_ASSIGN expr{  // declare and init
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_ASSIGN_DIV;
    node->addChild($1);
    node->addChild($3);
    $$ = node;   
} 
;

if
: S_IF  LPAREN expr RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_IF;
    node->addChild($3);
    node->addChild($5);
    $$ = node; 
}
;

while
: S_WHILE  LPAREN expr RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_WHILE;
    node->addChild($3);
    node->addChild($5);
    $$ = node; 
}
;

for
: S_FOR LPAREN expr SEMICOLON expr SEMICOLON expr RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_FOR;
    node->addChild($3);
    node->addChild($5);
    node->addChild($7);
    node->addChild($9);
    $$ = node; 
}
|S_FOR LPAREN declaration SEMICOLON expr SEMICOLON expr RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_FOR;
    node->addChild($3);
    node->addChild($5);
    node->addChild($7);
    node->addChild($9);
    $$ = node; 
}
|S_FOR LPAREN SEMICOLON expr SEMICOLON expr RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_FOR;
    nodenull->stype=STMT_SKIP; //for(;xxx;xxx)中的表达式为空
    node->addChild(nodenull);
    node->addChild($4);
    node->addChild($6);
    node->addChild($8);
    $$ = node; 
}
|S_FOR LPAREN expr SEMICOLON  SEMICOLON expr RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_FOR;
    nodenull->stype=STMT_SKIP; //for(xxx;;xxx)
    node->addChild($3);
    node->addChild(nodenull);
    node->addChild($6);
    node->addChild($8);
    $$ = node; 
}
|S_FOR LPAREN declaration SEMICOLON  SEMICOLON expr RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_FOR;
    nodenull->stype=STMT_SKIP; //for(xxx;;xxx)
    node->addChild($3);
    node->addChild(nodenull);
    node->addChild($6);
    node->addChild($8);
    $$ = node; 
}
|S_FOR LPAREN expr SEMICOLON  expr SEMICOLON  RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_FOR;
    nodenull->stype=STMT_SKIP; //for(xxx;xxx;)
    node->addChild($3);
    node->addChild($5);
    node->addChild(nodenull);
    node->addChild($8);
    $$ = node; 
}
|S_FOR LPAREN declaration SEMICOLON expr SEMICOLON  RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_FOR;
    nodenull->stype=STMT_SKIP; //for(xxx;xxx;)
    node->addChild($3);
    node->addChild($5);
    node->addChild(nodenull);
    node->addChild($8);
    $$ = node; 
}
|S_FOR LPAREN  SEMICOLON   SEMICOLON expr RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull1 = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull2 = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_FOR;
    nodenull1->stype=STMT_SKIP; //for(;;xxx)
    nodenull2->stype=STMT_SKIP;
    node->addChild(nodenull1);
    node->addChild(nodenull2);
    node->addChild($5);
    node->addChild($7);
    $$ = node; 
}
|S_FOR LPAREN  SEMICOLON  expr SEMICOLON  RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull1 = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull2 = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_FOR;
    nodenull1->stype=STMT_SKIP; //for(;xxx;)
    nodenull2->stype=STMT_SKIP;
    node->addChild(nodenull1);
    node->addChild($4);
    node->addChild(nodenull2);
    node->addChild($7);
    $$ = node; 
}
|S_FOR LPAREN expr SEMICOLON   SEMICOLON  RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull1 = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull2 = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_FOR;
    nodenull1->stype=STMT_SKIP; //for(xxx;;)
    nodenull2->stype=STMT_SKIP;
    node->addChild($3);
    node->addChild(nodenull1);
    node->addChild(nodenull2);
    node->addChild($7);
    $$ = node; 
}
|S_FOR LPAREN declaration SEMICOLON   SEMICOLON  RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull1 = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull2 = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_FOR;
    nodenull1->stype=STMT_SKIP; //for(xxx;;)
    nodenull2->stype=STMT_SKIP;
    node->addChild($3);
    node->addChild(nodenull1);
    node->addChild(nodenull2);
    node->addChild($7);
    $$ = node; 
}
|S_FOR LPAREN  SEMICOLON   SEMICOLON  RPAREN statements{
    TreeNode* node = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull1 = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull2 = new TreeNode($1->lineno, NODE_STMT);
    TreeNode* nodenull3 = new TreeNode($1->lineno, NODE_STMT);
    node->stype = STMT_FOR;
    nodenull1->stype=STMT_SKIP; //for(;;)
    nodenull2->stype=STMT_SKIP;
     nodenull3->stype=STMT_SKIP;
    node->addChild(nodenull1);
    node->addChild(nodenull2);
    node->addChild(nodenull3);
    node->addChild($6);
    $$ = node; 
}
;

return
: S_RETURN {$$=$1;}
| S_RETURN expr {
    $1->addChild($2);
    $$=$1;
}
;

printf
: PRINTF LPAREN funcRParams RPAREN {
    TreeNode *node=new TreeNode(lineno,NODE_STMT);
    node->stype=STMT_PRINTF;
    node->addChild($3);
    node->lineno = $3->lineno;
    $$=node;
}
;

scanf
: SCANF LPAREN funcRParams RPAREN {
    TreeNode *node=new TreeNode(lineno,NODE_STMT);
    node->stype=STMT_SCANF;
    node->addChild($3);
    node->lineno = $3->lineno;
    $$=node;
}
;

funcRParams
: expr {$$ = $1;}
| expr COMMA funcRParams {
    $1->addSibling($3);
    $$ = $1;
}
| {$$=nullptr;}
;

main
: T MAIN LPAREN funcRParams RPAREN statements {
    TreeNode *node = new TreeNode(lineno,NODE_STMT);
    node->stype = STMT_MAIN;
    node->addChild($1);
    node->addChild($4);
    node->addChild($6);
    node->lineno = $1->lineno;
    $$ = node;
}
;

expr
: IDENTIFIER {
    $$ = $1;
}
| TRUE {
    $$=$1;
}
| FALSE {
    $$ = $1;
}
| expr EQUAL expr {
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_EQUAL;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr NEQ expr {
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_NEQ;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr GT expr {
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_GT;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr LT expr {
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_LT;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr GEQ expr {
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_GEQ;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| expr LEQ expr {
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_LEQ;
    node->addChild($1);
    node->addChild($3);
    $$=node;
}
| NOT expr {
    TreeNode *node=new TreeNode($2->lineno,NODE_EXPR);
    node->optype=OP_NOT;
    node->addChild($2);
    $$=node;        
}
| expr AND expr{
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_AND;
    node->addChild($1);
    node->addChild($3);
    $$=node; 
}
| expr OR expr{
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_OR;
    node->addChild($1);
    node->addChild($3);
    $$=node; 
}
| INTEGER {
    $$ = $1;
}
| CHAR {
    $$ = $1;
}
| STRING {
    $$ = $1;
}
| expr ADD expr  {
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_ADD;
    node->addChild($1);
    node->addChild($3);
    $$=node; 
}
| expr SUB expr  {
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_SUB;
    node->addChild($1);
    node->addChild($3);
    $$=node; 
}
| expr MUL expr   {
   TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_MUL;
    node->addChild($1);
    node->addChild($3);
    $$=node; 
}
| expr DIV expr   {
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_DIV;
    node->addChild($1);
    node->addChild($3);
    $$=node; 
}
| LPAREN expr RPAREN    {
    $$=$2;
}
| expr MOD expr   {
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_MOD;
    node->addChild($1);
    node->addChild($3);
    $$=node; 
}
| SUB expr %prec UMINUS   {
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_UMINUS;
    //node->addChild($1);
    node->addChild($2);
    $$=node; 
}
| ADD expr %prec UPLUS   {
    TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_UPLUS;
    //node->addChild($1);
    node->addChild($2);
    $$=node; 
}
| expr MADD {
    TreeNode *node=new TreeNode($2->lineno,NODE_EXPR);
    node->optype=OP_MADD;
    //node->addChild($1);
    node->addChild($1);
    $$=node; 
}
| expr MSUB{
    TreeNode *node=new TreeNode($2->lineno,NODE_EXPR);
    node->optype=OP_MSUB;
    //node->addChild($1);
    node->addChild($1);
    $$=node; 
}
| LAND expr{
     TreeNode *node=new TreeNode($1->lineno,NODE_EXPR);
    node->optype=OP_LAND;
    //node->addChild($1);
    node->addChild($2);
    $$=node;
}
;

T: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
| T_STRING {$$ = new TreeNode(lineno,NODE_TYPE); $$->type=TYPE_STRING;}
| VOID {$$ = new TreeNode(lineno,NODE_TYPE); $$->type=TYPE_VOID;}
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}