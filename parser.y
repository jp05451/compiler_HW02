%{
#include "lex.yy.cpp"
// #include "symbolTable.hpp"

#define Trace(t)        printf(t)
// int yylex();
void yyerror(char *);
%}

/* tokens */
%token ID ARRAY BEG BOOL CHAR CONST DECREASING DEFAULT DO ELSE END EXIT FALSE FOR FUNCTION GET IF INT LOOP OF PUT PROCEDURE REAL RESULT RETURN SKIP STRING THEN TRUE VAR WHEN 
%token MOD ASSIGN SMALLER_EQUAL MORE_EQUAL NOT_EQUAL AND OR NOT NUMBER STR



%%
program:        declarations statments;
constants:       CONST ID ':' type ASSIGN constant_exp
                |CONST ID ASSIGN constant_exp

variable:       VAR ID ':' type ASSIGN constant_exp
                |VAR ID ':'type
                |VAR ID ASSIGN constant_exp

type:           BOOL
                |INT
                |REAL

constant_exp:   STRING
                |REAL
                |'-'REAL
                |TRUE
                |FALSE

array:          ARRAY ID ':' REAL '.''.' REAL OF type


declarations:   declarations declarations
                |declarations
                |variable
                |constants
                |function
                ;

statments:      statments statments
                |statment
                |
                ;

function:       FUNCTION ID '('functionVarA functionVarB ')' ':' type content END ID;

functionVarA:   ID ':' type
                |
                ;
functionVarB:   ',' ID ':' type
                |functionVarB functionVarB
                |
                ;
content:        content content
                |variable
                |constants
                |statments
                |
                ;

procedure:      ID '(' functionVarA functionVarB ')' content


statment:       block
                |simple
                |function_invocation
                |procedure_invacation
                |expression
                |conditional
                |loop
                ;

block:          BEG content END;

simple:         ID ASSIGN expression
                |PUT  '(' expression ')'
                |GET ID
                |RETURN
                |RESULT expression
                |EXIT WHEN bool_expression
                |SKIP

expression:     expression '+' expression
                |expression '-' expression
                |expression '*' expression
                |expression '/' expression
                |bool_expression
                |ID
                |ARRAY '[' INT ']'
                |constant_exp
                ;

bool_expression: expression '<' expression
                |expression '>' expression
                |expression SMALLER_EQUAL expression
                |expression MORE_EQUAL expression
                |expression '=' expression
                |expression 'NOT_EQUAL' expression
                |expression NOT expression
                |expression AND expression
                |expression OR expression
                ;

function_invocation: ID '(' functionInputA functionInputB ')'
                    |ID
                    ;

functionInputA: expression;
functionInputB: ',' expression;

conditional:    IF bool_expression THEN 
                content
                ELSE 
                content
                END IF
                |IF bool_expression THEN
                content
                END IF
                ;

loop:           LOOP
                content
                END LOOP
                |FOR ID ':' const_exp '.''.' constant_exp
                content
                END FOR
                |FOR DECREASING ID ':' const_exp '.''.' constant_exp
                content
                END FOR
                ;
const_exp:      INT
                |ID
                ;

procedure_invacation:   ID '(' functionInputA functionInputB ')'
                        |ID
                        ;





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
}
