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

#ifndef YY_YY_SRC_MAIN_TAB_H_INCLUDED
# define YY_YY_SRC_MAIN_TAB_H_INCLUDED
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
    T_CHAR = 258,
    T_INT = 259,
    T_STRING = 260,
    T_BOOL = 261,
    VOID = 262,
    LOP_ASSIGN = 263,
    ADD_ASSIGN = 264,
    SUB_ASSIGN = 265,
    MUL_ASSIGN = 266,
    DIV_ASSIGN = 267,
    S_IF = 268,
    S_WHILE = 269,
    S_RETURN = 270,
    S_FOR = 271,
    LPAREN = 272,
    RPAREN = 273,
    LBRACE = 274,
    RBRACE = 275,
    SEMICOLON = 276,
    COMMA = 277,
    OR = 278,
    AND = 279,
    EQUAL = 280,
    NEQ = 281,
    GT = 282,
    LT = 283,
    GEQ = 284,
    LEQ = 285,
    ADD = 286,
    SUB = 287,
    MUL = 288,
    DIV = 289,
    MOD = 290,
    NOT = 291,
    LAND = 292,
    TRUE = 293,
    FALSE = 294,
    IDENTIFIER = 295,
    INTEGER = 296,
    CHAR = 297,
    BOOL = 298,
    STRING = 299,
    PRINTF = 300,
    SCANF = 301,
    MAIN = 302,
    UMINUS = 303,
    UPLUS = 304,
    MADD = 305,
    MSUB = 306
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_SRC_MAIN_TAB_H_INCLUDED  */
