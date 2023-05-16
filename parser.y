%{
#include "lex.yy.cpp"
// #include "symbolTable.hpp"

#define Trace(t)        printf(t)
// int yylex();
void yyerror(char *);
%}

/* tokens */


%token ID ARRAY BEG BOOL CHAR CONST DECREASING DEFAULT DO ELSE END EXIT FALSE FOR FUNCTION GET IF INT LOOP OF PUT PROCEDURE REAL RESULT RETURN SKIP STRING THEN TRUE VAR WHEN 
%token MOD ASSIGN LESS_EQUAL MORE_EQUAL NOT_EQUAL AND OR NOT  STR INT_NUMBER REAL_NUMBER NEGATIVE

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

constant:       CONST ID ':' type ASSIGN const_exp
                |CONST ID ASSIGN const_exp
                ;

variable:       VAR ID ':' type
                |VAR ID ASSIGN const_exp
                |VAR ID ':' type ASSIGN const_exp
                ;

types:          type
                |array
                ;

array:          VAR ID ':' ARRAY ':' const_exp '.' '.' const_exp OF type
                ;

type:           BOOL
                |INT
                |REAL
                |STRING
                ;

function:       FUNCTION ID '(' ')' ':' types
                contents
                END ID
                |FUNCTION ID '(' functionVarA functionVarB ')' ':' types
                contents
                END ID
                ;



functionVarA:   ID ':' type
                |array
                ;

functionVarB:   functionVarB ',' ID ':' type
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

expressions:    NEGATIVE expressions
                |'(' expressions ')'
                |expressions '*' expressions
                |expressions '/' expressions
                |expressions MOD expressions
                |expressions '+' expressions
                |expressions '-' expressions
                |bool_expression
                |const_exp
                |ID '[' INT ']'
                ;
const_exp:      INT_NUMBER
                |REAL_NUMBER
                |STR
                |TRUE
                |FALSE
                ;
bool_expression:    expressions '<' expressions
                    |expressions LESS_EQUAL expressions
                    |expressions '=' expressions
                    |expressions MORE_EQUAL expressions
                    |expressions '>' expressions
                    |expressions NOT_EQUAL expressions
                    |expressions NOT expressions
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
                |FOR ID const_exp '.' '.' const_exp
                contents
                END LOOP
                |FOR DECREASING ID const_exp '.' '.' const_exp
                contents
                END LOOP

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
