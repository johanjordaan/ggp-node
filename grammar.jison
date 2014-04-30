

/* lexical grammar */
%lex

%options lex case-insensitive

%%
\s+                             /* skip whitespace */ 


"<="                            return '<=';

[a-zA-Z_][a-zA-Z0-9._\-]*       return 'CONSTANT';
[0-9]+                          return 'INTEGER'
[?][a-zA-Z0-9._]+               return 'VARIABLE';
"("                             return '(';
")"                             return ')';   

;.*(\n|<<EOF>>)                 /* skip comments */ 

 

/lex 

%start program

%% /* language grammar */

program 
    : statements                            { yy.program = $1; }
    |                                       { yy.program = []; }
    ;

statements
    : statements statement                  { $1.push($2); }
    | statement                             { $$ = [$1]; }
    ;

statement
    : relation                              { $$ = new yy.terms.RelationTerm($1); }          
    | rule                                  { $$ = new yy.terms.RuleTerm($1); }
    ;

relation
    : '(' term terms ')'                    { $3.unshift($2); $$ = yy.context.create_relation($3); }
    | '(' term ')'                          { $$ = yy.context.create_relation([$2]) }
    ;

rule
    : '(' '<=' rule_term rule_terms ')'     { $$ = yy.context.create_rule($3,$4); }
    ;

rule_terms
    : rule_terms rule_term                  { $1.push($2); }
    | rule_term                             { $$ = [$1]; }
    ;

terms 
    : terms term                            { $1.push($2); }
    | term                                  { $$ = [$1]; }
    ;

rule_term
    : relation                              { $$ = new yy.terms.RelationTerm($1); }
    | CONSTANT                              { $$ = new yy.terms.ConstantTerm($1); }
    ;

term
    : relation                              { $$ = new yy.terms.RelationTerm($1); }
    | rule                                  { $$ = new yy.terms.RuleTerm($1);}
    | CONSTANT                              { $$ = new yy.terms.ConstantTerm($1); }
    | VARIABLE                              { $$ = new yy.terms.VariableTerm($1); }
    | INTEGER                               { $$ = new yy.terms.ConstantTerm(Number($1)); }
    ;

