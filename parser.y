%{
#include<string.h>
#include<math.h>
#include "lex.yy.cpp"
#include "symbolTable.hpp"


#define Trace(t)        printf(t)
// int yylex();
void yyerror(char *);
symbolTable globalTable;

symbolData data;

%}



%union { 
    int dType;
    double value;
    int isConst;
    char dataIdentity[256];
}

%token <value> REAL INT STRING BOOL
%token <dataIdentity> ID TRUE FALSE INT_NUMBER REAL_NUMBER STR
%token <isConst> CONST

%type <dataIdentity> expressions 
%type <dataIdentity> bool_expression
%type <dataIdentity> const_exp
%type <dType> Types

/* tokens */
%token ARRAY BEG CHAR  DECREASING DEFAULT DO ELSE END EXIT  FOR FUNCTION GET IF LOOP OF PUT PROCEDURE RESULT RETURN SKIP THEN  VAR WHEN 
%token ASSIGN MOD 
%token LESS_EQUAL MORE_EQUAL NOT_EQUAL AND OR NOT 
%token INT_NUMBER REAL_NUMBER STR 
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
                |CONST ID ASSIGN const_exp
                {
                    printf("%d %s is %s",$1,$2,$4);
                }
                ;

variable:       VAR ID ':' Type
                |VAR ID ASSIGN const_exp
                |VAR ID ':' Type ASSIGN const_exp
                ;

Types:          Type
                |array
                ;

array:          VAR ID ':' ARRAY ':' const_exp '.' '.' const_exp OF Type
                ;

Type:           BOOL
                |INT
                |REAL
                |STRING
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
                |TRUE           {puts($1);strcpy($$,$1);}
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
    globalTable.dump();
}
