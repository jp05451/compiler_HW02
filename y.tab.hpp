/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_HPP_INCLUDED
# define YY_YY_Y_TAB_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ID = 258,
    ARRAY = 259,
    BEG = 260,
    BOOL = 261,
    CHAR = 262,
    CONST = 263,
    DECREASING = 264,
    DEFAULT = 265,
    DO = 266,
    ELSE = 267,
    END = 268,
    EXIT = 269,
    FALSE = 270,
    FOR = 271,
    FUNCTION = 272,
    GET = 273,
    IF = 274,
    INT = 275,
    LOOP = 276,
    OF = 277,
    PUT = 278,
    PROCEDURE = 279,
    REAL = 280,
    RESULT = 281,
    RETURN = 282,
    SKIP = 283,
    STRING = 284,
    THEN = 285,
    TRUE = 286,
    VAR = 287,
    WHEN = 288,
    MOD = 289,
    ASSIGN = 290,
    SMALLER_EQUAL = 291,
    MORE_EQUAL = 292,
    NOT_EQUAL = 293,
    AND = 294,
    OR = 295,
    NOT = 296,
    NUMBER = 297,
    STR = 298
  };
#endif
/* Tokens.  */
#define ID 258
#define ARRAY 259
#define BEG 260
#define BOOL 261
#define CHAR 262
#define CONST 263
#define DECREASING 264
#define DEFAULT 265
#define DO 266
#define ELSE 267
#define END 268
#define EXIT 269
#define FALSE 270
#define FOR 271
#define FUNCTION 272
#define GET 273
#define IF 274
#define INT 275
#define LOOP 276
#define OF 277
#define PUT 278
#define PROCEDURE 279
#define REAL 280
#define RESULT 281
#define RETURN 282
#define SKIP 283
#define STRING 284
#define THEN 285
#define TRUE 286
#define VAR 287
#define WHEN 288
#define MOD 289
#define ASSIGN 290
#define SMALLER_EQUAL 291
#define MORE_EQUAL 292
#define NOT_EQUAL 293
#define AND 294
#define OR 295
#define NOT 296
#define NUMBER 297
#define STR 298

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_HPP_INCLUDED  */
