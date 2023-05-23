%{
#include<string.h>
#include<math.h>
#include "lex.yy.cpp"
#include "symbolTable.hpp"


#define Trace(t)        printf(t)
// int yylex();
void yyerror(char *);
symbolTable currentTable;
vector<symbolTable> tableList;
int currentStack=0;
int stackNumber=0;
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
%type <dType> Types Type array function_invocation

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
                    currentTable.insert($2,intToType($4),is_constant,currentStack);
                }
                
                |CONST ID ASSIGN expressions
                {
                    // if($4!=$6)
                    //     yyerror("ERROR: const assign type error");
                    currentTable.insert($2,intToType($4),is_constant,currentStack);
                }
                ;

variable:       VAR ID ':' Type
                {
                    currentTable.insert($2,intToType($4),is_normal,currentStack);
                }
                |VAR ID ASSIGN const_exp
                {
                    // if($4!=$6)
                    //     yyerror("ERROR: const assign type error");
                    currentTable.insert($2,intToType($4),is_normal,currentStack);
                }
                |VAR ID ':' Type ASSIGN const_exp
                {
                    if($4!=$6)
                        yyerror("ERROR: const assign type error");
                    currentTable.insert($2,intToType($4),is_normal,currentStack);
                }
                
                ;

Types:          Type    {$$=$1;}  
                |array  {$$=$1;}  
                ;

array:          VAR ID ':' ARRAY ':' const_exp '.' '.' const_exp OF Type
                {
                    // currentTable.insert($2,)
                }
                ;

Type:           BOOL        {$$=$1;}
                |INT        {$$=$1;}
                |REAL       {$$=$1;}
                |STRING     {$$=$1;}
                ;

function:       FUNCTION ID '(' ')' ':' Types
                {
                    currentTable.insert($2,intToType($6),is_func,0);
                    currentStack=++stackNumber;
                }
                contents
                END ID
                {
                    currentStack=0;
                }
                |FUNCTION ID '(' functionVarA functionVarB ')' ':' Types
                contents
                END ID
                ;



functionVarA:   ID ':' Type
                |array
                ;

functionVarB:   functionVarB ',' ID ':' Type
                |
                ;

procedure:      PROCEDURE ID '(' ')'
                contents
                END ID
                |PROCEDURE ID '(' functionVarA functionVarB ')'
                contents
                END ID
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
                |conditional
                |loop
                ;

/* blocks:         blocks block
                |
                ; */
block:          BEG
                content
                END
                ;

simple:         ID ASSIGN expressions
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
                    if($2!=type_int||$2!=type_real)
                    {
                        yyerror("ERROR: unable to calculate negetive");
                    }
                    $$=$2;
                }
                |'(' expressions ')'            {$$=$2;}
                |expressions '*' expressions
                {
                    if($1!=$3)
                        yyerror("ERROR: type error");
                    $$=$1;
                }
                |expressions '/' expressions
                {
                    if($1!=$3)
                        yyerror("ERROR: type error");
                    $$=$1;
                }
                |expressions MOD expressions{
                    if($1!=$3)
                        yyerror("ERROR: type error");
                    $$=$1;
                }
                |expressions '+' expressions
                {
                    if($1!=$3)
                        yyerror("ERROR: type error");
                    $$=$1;
                }
                |expressions '-' expressions
                {
                    if($1!=$3)
                        yyerror("ERROR: type error");
                    $$=$1;
                }
                |bool_expression    {$$=$1;}
                |const_exp          {$$=$1;}
                |ID '[' INT ']'
                {
                    if(currentTable.lookup($1)==0)
                    {
                        yyerror("ERROR: ID not found");
                    }
                }
                |ID
                {
                if(currentTable.lookup($1)==0)
                    {
                        yyerror("ERROR: ID not found");
                    }
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
                        yyerror("ERROR:bool_expression type error");
                    $$=type_bool;
                    }     
                    |expressions LESS_EQUAL expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression type error");
                    $$=type_bool;
                    }     
                    |expressions '=' expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression type error");
                    $$=type_bool;
                    }     
                    |expressions MORE_EQUAL expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression type error");
                    $$=type_bool;
                    }     
                    |expressions '>' expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression type error");
                    $$=type_bool;
                    }     
                    |expressions NOT_EQUAL expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression type error");
                    $$=type_bool;
                    }     
                    |NOT expressions
                    {
                        $$=type_bool;
                    }
                    |expressions AND expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression type error");
                    $$=type_bool;
                    }     
                    |expressions OR expressions
                    {
                    if($1!=$3)
                        yyerror("ERROR:bool_expression type error");
                    $$=type_bool;
                    }     
                    ;
function_invocation:    ID '(' ')' 
                        |ID '(' functionInputA functionInputB ')'
                        ;
functionInputA:     expressions
                    ;
functionInputB:     functionInputB ',' expressions
                    |
                    ;

conditional:    IF bool_expression THEN
                contents
                ELSE
                content
                END IF
                |IF bool_expression THEN
                contents
                END IF

loop:           LOOP
                contents
                END LOOP
                |FOR ID ':' expressions  '.' '.' expressions
                contents
                END FOR
                |FOR DECREASING ID ':' expressions  '.' '.' expressions
                contents
                END FOR

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
    currentTable.dump();
}
