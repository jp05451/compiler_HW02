%{
#include<string.h>
#include<math.h>
#include "lex.yy.cpp"
#include "symbolTable.hpp"


#define Trace(t)        printf(t)
// int yylex();
void yyerror(char *);
symbolTable currentTable;
stack<symbolTable> tableStack;

symbolData data;

%}



%union { 
    int dType;
    double value;
    int isConst;
    char dataIdentity[256];
}

%token <dType> REAL INT STRING BOOL
%token <dataIdentity> ID TRUE FALSE INT_NUMBER REAL_NUMBER STR
%token <isConst> CONST VAR

%type <dataIdentity> expressions 
%type <dataIdentity> bool_expression
%type <dataIdentity> const_exp
%type <dType> Types Type

/* tokens */
%token ARRAY BEG CHAR  DECREASING DEFAULT DO ELSE END EXIT  FOR FUNCTION GET IF LOOP OF PUT PROCEDURE RESULT RETURN SKIP THEN  VAR WHEN 
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

constant:       CONST ID ':' Type ASSIGN const_exp
                {
                    // printf("%d %s is %s\n",$1,$2,$6);
                    if(currentTable.lookup($2)!=0)
                    {
                        char errorMSG[256]={'\0'};
                        sprintf(errorMSG,"%s redefine",$2);
                        yyerror(errorMSG);
                    }
                    if($4!=getType($6,0))
                    {
                        yyerror("invalid assign");
                    }
                    else
                    {
                        currentTable.insert($2,getType($6,1),$6);
                    }
                }
                |CONST ID ASSIGN const_exp
                {
                    // printf("%d %s is %s\n",$1,$2,$4);
                    if(currentTable.lookup($2)!=0)
                    {
                        char errorMSG[256]={'\0'};
                        sprintf(errorMSG,"%s redefine",$2);
                        yyerror(errorMSG);
                    }
                    else
                    {
                        currentTable.insert($2,getType($4,1),$4);
                    }
                }
                ;

variable:       VAR ID ':' Type
                {
                    // printf("%d %s is %s\n",$1,$2,$4);
                    if(currentTable.lookup($2)!=0)
                    {
                        char errorMSG[256]={'\0'};
                        sprintf(errorMSG,"%s redefine",$2);
                        yyerror(errorMSG);
                    }
                    else
                    {
                        if($4==0)
                            currentTable.insert($2,type_int,"");
                        else if($4==1)
                            currentTable.insert($2,type_real,"");
                        else if($4==2)
                            currentTable.insert($2,type_string,"");
                        else if($4==3)
                            currentTable.insert($2,type_bool,"");
                    }
                }
                |VAR ID ASSIGN const_exp
                {
                    // printf("%d %s is %s\n",$1,$2,$4);
                    if(currentTable.lookup($2)!=0)
                    {
                        char errorMSG[256]={'\0'};
                        sprintf(errorMSG,"%s redefine",$2);
                        yyerror(errorMSG);
                    }
                    else
                    {
                        if($4==0)
                            currentTable.insert($2,getType($4,0),$4);
                    }
                }

                |VAR ID ':' Type ASSIGN const_exp
                {

                    // printf("%d\n",$4);
                    // puts($6);
                    // printf("%d\n",getType("8",0));
                    if(currentTable.lookup($2)!=0)
                    {
                        char errorMSG[256]={'\0'};
                        sprintf(errorMSG,"%s redefine",$2);
                        yyerror(errorMSG);
                    }
                    else if($4!=getType($6,0))
                    {
                        yyerror("invalid assign");
                    }
                    else
                    {
                        printf("%s\n",$6);
                        if($4==0)
                            currentTable.insert($2,type_int,$6);
                        else if($4==1)
                            currentTable.insert($2,type_real,$6);
                        else if($4==2)
                            currentTable.insert($2,type_string,$6);
                        else if($4==3)
                            currentTable.insert($2,type_bool,$6);
                    }
                }
                ;

Types:          Type    
                |array
                ;

array:          VAR ID ':' ARRAY ':' const_exp '.' '.' const_exp OF Type
                ;

Type:           BOOL        {$$=$1;}
                |INT        {$$=$1;}
                |REAL       {$$=$1;}
                |STRING     {$$=$1;}
                ;

function:       FUNCTION ID '(' ')' ':' Types
                contents
                END ID
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
                |'(' expressions ')'
                |expressions '*' expressions
                |expressions '/' expressions
                |expressions MOD expressions
                |expressions '+' expressions
                |expressions '-' expressions
                |bool_expression
                |const_exp
                |ID '[' INT ']'
                |ID
                ;
const_exp:      INT_NUMBER      {strcpy($$,$1);}
                |REAL_NUMBER    {strcpy($$,$1);}
                |STR            {strcpy($$,$1);}
                |TRUE           {strcpy($$,$1);}
                |FALSE          {strcpy($$,$1);}
                ;
bool_expression:    '(' bool_expression ')'
                    |expressions '<' expressions
                    |expressions LESS_EQUAL expressions
                    |expressions '=' expressions
                    |expressions MORE_EQUAL expressions
                    |expressions '>' expressions
                    |expressions NOT_EQUAL expressions
                    |NOT expressions
                    |expressions AND expressions
                    |expressions OR expressions
                    ;
function_invocation:    ID '(' ')' 
                        |ID '(' functionInputA functionInputB ')'
                        ;
    /* procedure_invacation:   ID '(' ')'
                            |ID '(' functionInputA functionInputB ')'
                            ; */
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
