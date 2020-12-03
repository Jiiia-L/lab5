#ifndef TREE_H
#define TREE_H

#include "pch.h"
#include "type.h"

enum NodeType
{
    NODE_CONST, 
    NODE_VAR,
    NODE_EXPR,
    NODE_TYPE,

    NODE_STMT,
    NODE_PROG,
};

enum OperatorType
{
    OP_EQ,  // ==
    OP_NOT, //!
    OP_AND, //&&
    OP_OR, //||
    OP_ADD,
    OP_SUB,
    OP_DIV,
    OP_MUL,
    OP_MOD,
    OP_UMINUS,
    OP_UPLUS,
    OP_EQUAL,
    OP_NEQ,
    OP_GT,
    OP_LT,
    OP_GEQ,
    OP_LEQ,
    OP_MADD, //++
    OP_MSUB,  //--
    OP_LAND //&
};

//语句：赋值（=）、if、while、for、return.
enum StmtType {
    STMT_SKIP,
    STMT_DECL,
    STMT_ASSIGN,
    STMT_ASSIGN_ADD,
    STMT_ASSIGN_SUB,
    STMT_ASSIGN_MUL,
    STMT_ASSIGN_DIV,
    STMT_IF,
    STMT_WHILE,
    STMT_FOR,
    STMT_RETURN,
    STMT_SCANF,
    STMT_PRINTF,
    STMT_MAIN
}
;

struct TreeNode {
public:
    int nodeID;  // 用于作业的序号输出
    int lineno;
    NodeType nodeType;

    TreeNode* child = nullptr;
    TreeNode* sibling = nullptr;

    void addChild(TreeNode*);
    void addSibling(TreeNode*);
    
    void printNodeInfo();
    void printChildrenId();

    void printAST(); // 先输出自己 + 孩子们的id；再依次让每个孩子输出AST。
    void printSpecialInfo();

    void genNodeId();

public:
    OperatorType optype;  // 如果是表达式
    Type* type;  // 变量、类型、表达式结点，有类型。
    StmtType stype;
    int int_val;
    char ch_val;
    bool b_val;
    string str_val;
    string var_name;
public:
    static string nodeType2String (NodeType type);
    static string opType2String (OperatorType type);
    static string sType2String (StmtType type);

public:
    TreeNode(int lineno, NodeType type);
};

#endif