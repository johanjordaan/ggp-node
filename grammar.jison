/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex

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
    : statements                    { console.log('program>',$1); }
    ;

statements
    : statements statement          { $1.push($2); }
    | statement                     { $$ = [$1]; }
    ;

statement
    : relation                      { console.log('statement(rel)>',$1); }
    | rule                          { console.log('statement(rul)>',$1); }
    ;

relations
    : relations relation            { $1.push($2); }
    | relation                      { $$ = [$1]; }
    ;

relation
    : '(' relation_name terms ')'   { console.log('rel(k)>',$2,$3); $$ = { t:'relation', n:$2, v:$3 } }
    | '(' relation_name ')'         { console.log('rel(e)>',$2); }
    | '(' term terms ')'            { console.log('rel(t)>',$2,$3); $$ = { t:'terms_relation', v:$2 }} 
    | '(' term ')'                  { console.log('rel(ts)>',$2,$3); $$ = { t:'terms_relation', v:$2 }} 
    ;

rule
    : '(<=' relation relations ')'  { console.log('rule(.)>',$2,$3); $$ = { t:'rule', h:$2, t:$3 }; }
    ;

terms 
    : terms term                    { $1.push($2); }
    | term                          { $$ = [$1]; }
    ;

term
    : relation                      { console.log('term(r)>',$1); }
    | rule                          { console.log('term(u)>',$1); }
    | CONSTANT                      { console.log('term(c)>',$1); $$ = { t:'constant', v:$1 } }
    | VARIABLE                      { console.log('term(v)>',$1); $$ = { t:'variable', v:$1 } }
    ;

relation_name
    : command_relation              { console.log('rname(cmd)>',$1); $$ = { t:'command_relation', v:$1 } }
    | gdl_relation                  { console.log('rname(gdl)>',$1); $$ = { t:'gdl_relation', v:$1 } }
    | logic_relation                { console.log('rname(lgc)>',$1); $$ = { t:'logic_relation', v:$1 } }
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

