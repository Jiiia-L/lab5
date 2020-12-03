%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
int lineno=1;
%}
BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*
EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]

INTEGER [0-9]+

CHAR \'.?\'
STRING \".+\"

IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*
%%

{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */


"int" return T_INT;
"bool" return T_BOOL;
"string" return T_STRING;
"char" return T_CHAR;
"void" return VOID;
"printf" return PRINTF;
"scanf" return SCANF;
"main" return MAIN;

"==" return EQUAL;
"!=" return NEQ;
"<=" return LEQ;
">=" return GEQ;
"<" return LT;
">" return GT;
"+" return ADD;
"-" return SUB;
"*" return MUL;
"/" return DIV;
"%" return MOD;
"!" return NOT;
"=" return LOP_ASSIGN;
"||" return OR;
"&&" return AND;
"&" return LAND;
"+=" return ADD_ASSIGN;
"-=" return SUB_ASSIGN;
"*=" return MUL_ASSIGN;
"/=" return DIV_ASSIGN;
"++" return MADD;
"--" return MSUB;

";" return  SEMICOLON;
"," return COMMA;
"(" return LPAREN;
")" return RPAREN;
"{" return LBRACE;
"}" return RBRACE;

"if" return S_IF;
"while" return S_WHILE;
"return" {
    TreeNode *node = new TreeNode(lineno,NODE_STMT);
    node->stype = STMT_RETURN;
    yylval = node;
    return S_RETURN;
    }
"for" return S_FOR;

"true" {
    TreeNode *node = new TreeNode(lineno,NODE_CONST);
    node->type = TYPE_BOOL;
    node->b_val = true;
    yylval = node;
    return TRUE;
}
"false" {
    TreeNode *node = new TreeNode(lineno,NODE_CONST);
    node->type = TYPE_BOOL;
    node->b_val = false;
    yylval = node;
    return FALSE;
}

{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}

{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->ch_val = yytext[1];
    yylval = node;
    return CHAR;
}

{STRING} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_STRING;
    node->str_val = yytext;
    yylval = node;
    return STRING;
}

{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}

{WHILTESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%