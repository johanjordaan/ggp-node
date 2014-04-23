

/* lexical grammar */
%lex

%options lex case-insensitive

%%
\s+                             /* skip whitespace */ 

"(<="                           return '(<=';

[a-zA-Z_][a-zA-Z0-9._]*         return 'CONSTANT';
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
    : relation                      
    | rule                          
    ;

relations
    : relations relation            { $1.push($2); }
    | relation                      { $$ = [$1]; }
    ;

relation
    : '(' term terms ')'                   { $$ = new yy.Relation($2,$3) }
    | '(' term ')'                         { $$ = new yy.Relation($2,[]) }
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
    | INTEGER                       { $$ = new yy.ConstantTerm($1); }
    ;

