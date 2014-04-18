/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex
%option case-insensitive

%%
\s+                             /* skip whitespace */ 

"INFO"                          return 'INFO';
"START"                         return 'START'
"PLAY"                          return 'PLAY';
"STOP"                          return 'STOP';
"ABORT"                         return 'ABORT';

"ROLE"                          return 'ROLE';
"BASE"                          return 'BASE';
"INPUT"                         return 'INPUT';
"INIT"                          return 'INIT';
"TRUE"                          return 'TRUE';
"DOES"                          return 'DOES';
"NEXT"                          return 'NEXT';
"LEGAL"                         return 'LEGAL';
"GOAL"                          return 'GOAL';
"TERMINAL"                      return 'TERMINAL';

"NOT"                           return 'NOT';
"AND"                           return 'AND';

"(<="                           return '(<=';

[a-zA-Z0-9._]+                  return 'CONSTANT';
[0-9]+                          return 'INTEGER'
[?][a-zA-Z0-9._]+               return 'VARIABLE';
"("                             return '(';
")"                             return ')';   

;[^\n]*((\n)|<<EOF>>)           /* skip comments */ 
 


/lex 

%start program


%% /* language grammar */

program
    : statements     
    ;

statements
    : statements statement
    | statement
    ;

statement
    : relation
    | rule
    ;

relations
    : relations relation
    | relation
    ;

relation
    : '(' relation_name terms ')'
    | '(' relation_name ')'
    | '(' terms ')'
    ;

rule
    : '(<=' relation relations ')'
    ;

terms 
    : terms term
    | term
    ;

term
    : CONSTANT
    | VARIABLE
    | relation
    | rule
    ;

relation_name
    : command_relation
    | gdl_relation
    | logic_relation
    ;

command_relation
    : INFO
    | START
    | PLAY
    | STOP
    | ABORT
    ;

gdl_relation
    : ROLE
    | CONTROL
    | TRUE
    | INIT
    | NEXT
    | LEGAL
    | GOAL
    | DOES
    ;

logic_relation
    : NOT
    | AND
    | OR
    ;

