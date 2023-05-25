%{
#include<string.h>
#include "lex.yy.cpp"
#include "symbolTable.hpp"


#define Trace(t)        printf(t)
// int yylex();
void yyerror(char *);
symbolTable s_table;
int currentStack=0;
int stackNumber=0;

// typedef struct funcVar
// {
//     string varID;
//     dataType funcVarType;
//     bool isArray;
// }
// funcVar;

vector<funcVar> functionVariable;
stack<int> scopeStack;

%}



%union { 
    int dType;
    double value;
    char dataIdentity[256];
}

%token <dType> REAL INT STRING BOOL TRUE FALSE INT_NUMBER REAL_NUMBER STR
%token <dataIdentity> ID 

%type <dType> expressions 
%type <dType> bool_expression
%type <dType> const_exp
%type <dType> Types Type array function_invocation functionVarA functionVarB

/* tokens */
%token ARRAY BEG CHAR  DECREASING DEFAULT DO ELSE END EXIT  FOR FUNCTION GET IF LOOP OF PUT PROCEDURE RESULT RETURN SKIP THEN  VAR WHEN CONST 
%token ASSIGN MOD 
%token LESS_EQUAL MORE_EQUAL NOT_EQUAL AND OR NOT 
/* %token INT_NUMBER REAL_NUMBER STR  */
    /* TRUE FALSE */

%left OR
%left AND
%left NOT
%left '<' LESS_EQUAL '=' MORE_EQUAL '>' NOT_EQUAL
%left '+' '-'
%left '*' '/' MOD
%nonassoc NEGATIVE





%%

program:        declarations statments;

declarations:   declarations declaration
                |
                ;

statments:      statments statment
                |
                ;

declaration:    constant
                |variable
                |array
                |function
                |procedure
                ;

constant:       CONST ID ':' Type ASSIGN expressions
                {
                    if($4!=$6)
                        yyerror("ERROR: const assign type error");
                    else
                        s_table.insert($2,intToType($4),is_constant,currentStack);
                }
                
                |CONST ID ASSIGN expressions
                {
                    // if($4!=$6)
                    //     yyerror("ERROR: const assign type error");
                    s_table.insert($2,intToType($4),is_constant,currentStack);
                }
                ;

variable:       VAR ID ':' Type
                {
                    s_table.insert($2,intToType($4),is_normal,currentStack);
                }
                |VAR ID ASSIGN const_exp
                {
                    // if($4!=$6)
                    //     yyerror("ERROR: const assign type error");
                    s_table.insert($2,intToType($4),is_normal,currentStack);
                }
                |VAR ID ':' Type ASSIGN const_exp
                {
                    if($4!=$6)
                        yyerror("ERROR: const assign type error");
                    s_table.insert($2,intToType($4),is_normal,currentStack);
                }
                
                ;

Types:          Type    {$$=$1;}  
                |array  {$$=$1;}  
                ;

array:          VAR ID ':' ARRAY  const_exp '.' '.' const_exp OF Type
                {
                    s_table.insert($2,intToType($10),is_arr,currentStack);
                    $$ = $10;
                }
                ;

Type:           BOOL        {$$=$1;}
                |INT        {$$=$1;}
                |REAL       {$$=$1;}
                |STRING     {$$=$1;}
                ;

function:       FUNCTION ID '(' ')' ':' Types
                {
                    s_table.insert($2,intToType($6),is_func,0);
                    s_table.table[$2].fData.varNumber=0;
                    currentStack=++stackNumber;    
                }
                contents
                END ID
                {
                    currentStack=0;
                }
                |FUNCTION ID '(' functionVarA functionVarB ')' ':' Types
                {
                    // s_table.insert($2,intToType($9),is_func,0);
                    // {currentStack=++stackNumber;}
                    s_table.insert($2,intToType($8),is_func,0);
                    currentStack=++stackNumber;
                    for(auto &fVar:functionVariable)
                    {
                        s_table.table[$2].fData.functionVar.push_back(fVar.funcVarType);
                        //insert variable in functionData

                        s_table.insert(fVar.varID,fVar.funcVarType,fVar.isArray? is_arr:is_normal,currentStack);
                        //insert variable to symbolTable
                    }
                    s_table.table[$2].fData.varNumber=functionVariable.size();

                }
                contents
                END ID
                {
                    currentStack=0;
                    functionVariable.clear();
                }
                ;



functionVarA:   ID ':' Type
                {
                    // s_table.insert($1,intToType($3),is_normal,currentStack);
                    funcVar temp;
                    temp.varID=$1;
                    temp.funcVarType=intToType($3);
                    temp.isArray=0;
                    functionVariable.push_back(temp);
                }
                |ID ':' ARRAY const_exp '.' '.' const_exp OF Type
                {
                    // s_table.insert($1,intToType($9),is_arr,currentStack);
                    funcVar temp;
                    temp.varID=$1;
                    temp.funcVarType=intToType($9);
                    temp.isArray=1;
                    functionVariable.push_back(temp);
                }
                ;

functionVarB:   functionVarB ',' ID ':' Type
                {
                    // s_table.insert($3,intToType($5),is_normal,currentStack);
                    funcVar temp;
                    temp.varID=$3;
                    temp.funcVarType=intToType($5);
                    temp.isArray=0;
                    functionVariable.push_back(temp);
                }
                |functionVarB ',' ID ':' ARRAY const_exp '.' '.' const_exp OF Type
                {
                    // s_table.insert($3,intToType($11),is_arr,currentStack);
                    funcVar temp;
                    temp.varID=$3;
                    temp.funcVarType=intToType($11);
                    temp.isArray=1;
                    functionVariable.push_back(temp);
                }
                |
                ;

procedure:      PROCEDURE ID '(' ')'
                {
                    s_table.insert($2,type_null,is_func,0);
                    currentStack=++stackNumber;

                }
                contents
                END ID
                {
                    currentStack=0;
                }
                |PROCEDURE ID '(' functionVarA functionVarB ')'
                {
                    // s_table.insert($2,intToType($9),is_func,0);
                    // {currentStack=++stackNumber;}
                    s_table.insert($2,type_null,is_func,0);
                    currentStack=++stackNumber;
                    for(auto &fVar:functionVariable)
                    {
                        s_table.table[$2].fData.functionVar.push_back(fVar.funcVarType);
                        //insert variable to function Data

                        s_table.insert(fVar.varID,fVar.funcVarType,fVar.isArray? is_arr:is_normal,currentStack);
                        //insert variable to symbolTable
                    }
                    s_table.table[$2].fData.varNumber=functionVariable.size();
                }
                contents
                END ID
                {
                    currentStack=0;
                    functionVariable.clear();
                }
                ;

contents:       contents content
                |
                ;

content:        variable    
                |constant
                |array
                |statment
                ;

statment:       block
                |simple
                |expressions
                |function_invocation
                {
                    functionVariable.clear();
                }
                |conditional
                |loop
                ;


block:          BEG     
                {
                    scopeStack.push(currentStack);
                    currentStack=++stackNumber;
                    s_table.insertStack(scopeStack.top(),currentStack);
                }
                content
                END     
                {
                    if(scopeStack.empty())
                    {
                        currentStack=0;
                    }
                    else
                    {
                        currentStack=scopeStack.top();
                        scopeStack.pop();
                    }
                }
                ;

simple:         ID ASSIGN expressions
                {
                    if(s_table.lookup($1)==0)
                    //symbol is not declare
                    {
                        printf("ERROR: %s not declare\n",$1);
                    }
                    else if(s_table.table[$1].masterType==is_constant)
                    //symbol is constant
                    {
                        printf("ERROR %s is constant unable to assign\n",$1);
                    }
                    else if(s_table.table[$1].type!=$3)
                    //type error
                    {
                        printf("ERROR: %s assign type error\n",$1);
                    }
                    else if(s_table.canAccess($1,currentStack)==0)
                    {
                        printf("ERROR: %s is unable to access\n",$1);
                    }   

                }
                |PUT expressions
                |GET expressions
                |RESULT expressions
                |RETURN
                |EXIT
                |EXIT WHEN bool_expression
                |SKIP
                ;


    //======================expression=====================
expressions:    '-' expressions %prec NEGATIVE  
                {
                    if($2!=type_int && $2!=type_real)
                    {
                        printf("ERROR: %d unable to calculate negetive\n",$2);
                    }
                    $$=$2;
                }
                |'(' expressions ')'            {$$=$2;}
                |expressions '*' expressions
                {
                    if($1!=$3)
                        yyerror("ERROR: expression '*' type error");
                    $$=$1;
                }
                |expressions '/' expressions
                {
                    if($1!=$3)
                        yyerror("ERROR: expression '/' type error");
                    $$=$1;
                }
                |expressions MOD expressions{
                    if($1!=$3)
                        yyerror("ERROR: expression '%' type error");
                    $$=$1;
                }
                |expressions '+' expressions
                {
                    if($1!=$3)
                        yyerror("ERROR: expression '+' type error");
                    $$=$1;
                }
                |expressions '-' expressions
                {
                    if($1!=$3)
                        yyerror("ERROR: expression '-' type error");
                    $$=$1;
                }
                |bool_expression    {$$=$1;}
                |const_exp          {$$=$1;}
                |function_invocation
                {
                    functionVariable.clear();
                }
                |ID '[' INT ']'
                {
                    if(s_table.lookup($1)==0)
                    {
                        printf("ERROR: ID %s not found\n",$1);
                    }
                    else if(s_table.canAccess($1,currentStack)==0)
                    {
                        printf("ERROR: %s is unable to reach\n",$1);
                        $$=s_table.table[$1].type;
                    }
                    else
                        $$=s_table.table[$1].type;
                }
                |ID
                {
                    if(s_table.lookup($1)==0)
                    {
                        printf("ERROR: ID %s not found\n",$1);
                    }
                    else if(s_table.canAccess($1,currentStack)==0)
                    {

                        printf("ERROR: %s stack: %d is unable to reach\n",$1,currentStack);
                        $$=s_table.table[$1].type;
                    }
                    else
                        $$=s_table.table[$1].type;
                }
                ;
const_exp:      INT_NUMBER      {$$=$1;}
                |REAL_NUMBER    {$$=$1;}
                |STR            {$$=$1;}
                |TRUE           {$$=$1;}
                |FALSE          {$$=$1;}
                ;
bool_expression:    '(' bool_expression ')'             {$$=$2;}
                    |expressions '<' expressions   
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression '<' type error");
                    $$=type_bool;
                    }     
                    |expressions LESS_EQUAL expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression '<=' type error");
                    $$=type_bool;
                    }     
                    |expressions '=' expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression '=' type error");
                    $$=type_bool;
                    }     
                    |expressions MORE_EQUAL expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression '>=' type error");
                    $$=type_bool;
                    }     
                    |expressions '>' expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression '>' type error");
                    $$=type_bool;
                    }     
                    |expressions NOT_EQUAL expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression '!=' type error");
                    $$=type_bool;
                    }     
                    |NOT expressions
                    {
                        $$=type_bool;
                    }
                    |expressions AND expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression 'AND' type error");
                    $$=type_bool;
                    }     
                    |expressions OR expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression 'OR' type error");
                    $$=type_bool;
                    }     
                    ;
function_invocation:    ID '(' ')' 
                        {
                            if(s_table.lookup($1)==0)
                            {
                                yyerror("ERROR: function not declare");
                            }
                            else if(s_table.table[$1].masterType!=is_func)
                            {
                                printf("ERROR: %s is not function\n",$1);
                                $$=s_table.table[$1].type;
                            }
                            else
                            {
                                $$=s_table.table[$1].type;
                            }
                        }
                        |ID '(' functionInputA functionInputB ')'
                        {
                            if(s_table.lookup($1)==0)
                            {
                                printf("ERROR: function %s not declare\n",$1);
                            }
                            else if(s_table.table[$1].masterType!=is_func)
                            {
                                printf("ERROR: %s is not function\n",$1);
                                $$=s_table.table[$1].type;

                            }
                            else if(s_table.funcVarCorrect($1,functionVariable)==0)
                            {
                                printf("ERROR: function %s input error\n",$1);
                                $$=s_table.table[$1].type;
                            }
                            else
                            {
                                $$=s_table.table[$1].type;
                            }
                        }
                        ;
functionInputA:     expressions
                    {
                        funcVar temp;
                        temp.funcVarType=intToType($1);
                        temp.isArray=0;
                        functionVariable.push_back(temp);
                    }
                    ;
functionInputB:     functionInputB ',' expressions
                    {
                        funcVar temp;
                        temp.funcVarType=intToType($3);
                        temp.isArray=0;
                        functionVariable.push_back(temp);
                    }
                    |
                    ;

conditional:    IF bool_expression THEN
                {
                    scopeStack.push(currentStack);
                    currentStack=++stackNumber;
                    s_table.insertStack(scopeStack.top(),currentStack);
                }
                contents
                ELSE
                content
                END IF
                {
                    if(scopeStack.empty())
                    {
                        currentStack=0;
                    }
                    else
                    {
                        currentStack=scopeStack.top();
                        scopeStack.pop();
                    }
                }
                |IF bool_expression THEN
                {
                    scopeStack.push(currentStack);
                    currentStack=++stackNumber;
                    s_table.insertStack(scopeStack.top(),currentStack);
                }
                contents
                END IF
                {
                    if(scopeStack.empty())
                    {
                        currentStack=0;
                    }
                    else
                    {
                        currentStack=scopeStack.top();
                        scopeStack.pop();
                    }
                }

loop:           LOOP
                {
                    scopeStack.push(currentStack);
                    currentStack=++stackNumber;
                    s_table.insertStack(scopeStack.top(),currentStack);

                }
                contents
                END LOOP
                {
                    if(scopeStack.empty())
                    {
                        currentStack=0;
                    }
                    else
                    {
                        currentStack=scopeStack.top();
                        scopeStack.pop();
                    }
                }
                |FOR ID ':' expressions  '.' '.' expressions
                {
                    if(s_table.lookup($2)==0)
                    {
                        printf("ERROR: for loop $s not found\n",$2);
                    }
                    if($4!=$7)
                    {
                        printf("ERROR: for loop range error\n");
                    }
                    scopeStack.push(currentStack);
                    currentStack=++stackNumber;
                    s_table.insertStack(scopeStack.top(),currentStack);
                }
                contents
                END FOR
                {
                    if(scopeStack.empty())
                    {
                        currentStack=0;
                    }
                    else
                    {
                        currentStack=scopeStack.top();
                        scopeStack.pop();
                    }
                }
                |FOR DECREASING ID ':' expressions  '.' '.' expressions
                {
                    if(s_table.lookup($3)==0)
                    {
                        printf("ERROR: for loop $s not found\n",$3);
                    }
                    if($5!=$8)
                    {
                        printf("ERROR: for loop range error\n");
                    }
                    scopeStack.push(currentStack);
                    currentStack=++stackNumber;
                    s_table.insertStack(scopeStack.top(),currentStack);
                }
                contents
                END FOR
                {
                    if(scopeStack.empty())
                    {
                        currentStack=0;
                    }
                    else
                    {
                        currentStack=scopeStack.top();
                        scopeStack.pop();
                    }
                }

%%

void yyerror(char *msg)
{
    fprintf(stderr, "%s\n", msg);
}

int main(int argc,char **argv)
{
    /* open the source program file */
    if (argc != 2) {
        printf ("Usage: sc filename\n");
        exit(1);
    }
    yyin = fopen(argv[1], "r");         /* open input file */

    /* perform parsing */
    if (yyparse() == 1)                 /* parsing */
        yyerror("Parsing error !");     /* syntax error */
    s_table.dump();
}
