#include "tree.h"
#include<iomanip>
int nodeIDCount=0;
void TreeNode::addChild(TreeNode* child) {
    if(this->child==nullptr){
        this->child=child;
    }
    else{
        this->child->addSibling(child);
    }
}

void TreeNode::addSibling(TreeNode* sibling){
    if(this->sibling==nullptr){
        this->sibling=sibling;
    }
    else{
        this->sibling->addSibling(sibling);
    }
}

TreeNode::TreeNode(int lineno, NodeType type) {
    this->lineno = lineno;
    this->nodeType = type;
}

void TreeNode::genNodeId() {
    this->nodeID = nodeIDCount++;
    if(this->child)
        this->child->genNodeId();
    if(this->sibling)
        this->sibling->genNodeId();
}

void TreeNode::printNodeInfo() {
    string NODETYPE=this->nodeType2String(this->nodeType);
    
    cout<<"lno@"<<this->lineno<<std::setw(5)<<"@"<<this->nodeID<<std::setw(10)<<NODETYPE<<"  ";
    this->printSpecialInfo();
    cout<<endl;
}

void TreeNode::printChildrenId() {
    if(this->child!=nullptr){
        cout<<"children:[ ";
        //cout<<this->child->nodeID<<" ";
        cout << "@" << this->child->nodeID << " ";
        TreeNode *tmp = this->child->sibling;
        while (tmp!= nullptr)
        {
            cout << "@" << tmp->nodeID << " ";
            tmp = tmp->sibling;
        }
        cout<<"]  ";
    }
}

void TreeNode::printAST() {
// 先输出自己 + 孩子们的id；再依次让每个孩子输出AST。
this->printNodeInfo();
if(this->child!=nullptr){
    this->child->printAST();
}
if(this->sibling!=nullptr){
    this->sibling->printAST();
}
}


// You can output more info...
void TreeNode::printSpecialInfo() {
    //prog,stmt,expr有孩子
    switch(this->nodeType){
        case NODE_CONST:
            cout<<"type: "<<this->type->getTypeInfo();
            break;
        case NODE_VAR:
            cout<<"varname: "<<this->var_name;
            break;
        case NODE_EXPR:
            this->printChildrenId();
            cout<<"optype: "<<opType2String(this->optype);
            break;
        case NODE_STMT:
            this->printChildrenId();
            cout<<"stmt: "<<sType2String(this->stype);
            break;
        case NODE_TYPE:
            cout<<"type: "<<this->type->getTypeInfo();
            break;
        default:
            this->printChildrenId();
            break;
    }
}

string TreeNode::sType2String(StmtType type) {
    switch(type){
        case STMT_SKIP:
            return "skip";
        case STMT_DECL:
            return "decl";
        case STMT_ASSIGN:
            return "assign";
        case STMT_ASSIGN_ADD:
            return "assign_add";
        case STMT_ASSIGN_DIV:
            return "assign_div";
        case STMT_ASSIGN_MUL:
            return "assign_mul";
        case STMT_ASSIGN_SUB:
            return "assign_sub";
        case STMT_IF:
            return "if";
        case STMT_WHILE:
            return "while";
        case STMT_FOR:
            return "for";
        case STMT_RETURN:
            return "return";
        case STMT_MAIN:
            return "main";
        case STMT_SCANF:
            return "scanf";
        case STMT_PRINTF:
            return "printf";
        default:
            return "?";
    }
    return "?";
}


string TreeNode::nodeType2String (NodeType type){
    string NODETYPE="";
    if(type==NODE_CONST){
        NODETYPE="const";
    }
    else if(type==NODE_EXPR){
        NODETYPE="expression";
        //CHILD="children:[";
    }
    else if(type==NODE_VAR){
        NODETYPE="variable";
    }
    else if(type==NODE_TYPE){
        NODETYPE="type";
    }
    else if(type==NODE_STMT){
        NODETYPE="statement";
        //CHILD="children:[";
    }
    else if(type==NODE_PROG){
        NODETYPE="program";
        //CHILD="children:[ ";
    }
    return NODETYPE;
}

string TreeNode::opType2String(OperatorType type) {
    switch (type)
    {
    case OP_EQ:
        return "==";
        break;
    case OP_NOT:
        return "!";
    case OP_AND:
        return "&&";
    case OP_OR:
        return "||";
    case OP_SUB:
        return "-";
    case OP_ADD:
        return "+";

    case OP_DIV:
        return "/";
        break;
    case OP_MUL:
        return "*";
    case OP_MOD:
        return "%";
    case OP_UMINUS:
        return "-";
    case OP_UPLUS:
        return "+";
    case OP_EQUAL:
        return "==";

    case OP_NEQ:
        return "!=";
        break;
    case OP_GT:
        return ">";
    case OP_LT:
        return "<";
    case OP_GEQ:
        return ">=";
    case OP_LEQ:
        return "<=";
    case OP_MADD:
        return "++";
    case OP_MSUB:
        return "--";
    case OP_LAND:
        return "&";
    default:
        return "?";
        break;
    }
}