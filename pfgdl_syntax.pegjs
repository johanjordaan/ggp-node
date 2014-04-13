{
  var gdl_ast = require("./gdl_ast.js");

  var create_list = function(first,rest) {
    var ret_val = [first];
    for(var i=0;i<rest.length();i++) {
      ret_val.push(rest[i]);
    }
    return ret_val;
  }
}

program 
  = statements:statement*  { return new gdl_ast.Program(statements); }

statement 
  = OWS rule:rule OWS 
  / OWS atom:atom OWS { return atom; }
  / OWS comment OWS

rule 
  = "(<=" WS atom WS body OWS ")"  

body 
  = literals

literals
  = literal WS literals  
  / literal

literal
  = atom 
  / negated_atom

atom 
  = "(" OWS name:relation_constant WS parms:terms OWS ")" { return new gdl_ast.Relation(name,parms); }
  / "(" OWS name:relation_constant WS parms:atom OWS ")" 
  / negated_atom 

negated_atom
  = "(not" WS atom OWS ")"

functional_term
  = function_constant WS terms  

terms
  = term
  / first:term WS rest:terms
    

term 
  = name:object_constant  { return new gdl_ast.ObjectConstant(name); }
  / name:variable         { return new gdl_ast.Variable(name); }  
  / functional_term       

comment 
  = first:";" rest:(!LT.)* 

object_constant
  = str:[a-zA-Z0-9]+ { return str.join(""); }

function_constant 
  = str:[a-zA-Z]+ { return str.join(""); }

relation_constant
  = str:[a-zA-Z]+ { return str.join(""); }

variable 
  = first:[?] rest:[a-z]+ { return rest.join(""); } 


LT "line terminator"
  = [\n\r\u2028\u2029]

WS "whitespace"
  = [ \t\n\r]+

OWS "optional whitespace"
  = [ \t\n\r]*

