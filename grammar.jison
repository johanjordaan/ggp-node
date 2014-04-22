

/* lexical grammar */
%lex

%options lex case-insensitive

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
    : statements                    { yy.program = $1 }
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
    : known_relation
    | anonymous_relation
    | list_relation
    ;

known_relation
    : '(' relation_name terms ')'   { $2.terms = $3; $$ = $2; }
    | '(' relation_name ')'         { $$ = $2; }
    ;

anonymous_relation
    : '(' CONSTANT terms ')'        { $$ = new yy.AnonymousRelation($2,$3); } 
    | '(' CONSTANT ')'              { $$ = new yy.AnonymousRelation($2,[]); }
    ;

list_relation
    : '(' relation terms ')'        { $3.unshift($2); $$ = new yy.ListRelation($3); } 
    | '(' relation ')'              { $$ = new yy.ListRelation([$2]); } 
    | '(' rule terms ')'            { $3.unshift($2); $$ = new yy.ListRelation($3); }     
    | '(' rule ')'                  { $$ = new yy.ListRelation([$2]); } 
    ;

rule
    : '(<=' relation relations ')'  { $$ = new yy.Rule($2,$3); }
    ;

terms 
    : terms term                    { $1.push($2); }
    | term                          { $$ = [$1]; }
    ;

term
    : relation                      { $$ = new yy.RelationTerm($1); }
    | rule                          { $$ = new yy.RuleTerm($1);}
    | CONSTANT                      { $$ = new yy.ConstantTerm($1); }
    | VARIABLE                      { $$ = new yy.VariableTerm($1); }
    ;

relation_name
    : command_relation              { $$ = new yy.CommandRelation($1,[]); }
    | gdl_relation                  { $$ = new yy.GDLRelation($1,[]); }
    | logic_relation                { $$ = new yy.LogicRelation($1,[]); }
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

