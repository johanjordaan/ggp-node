_ = require("underscore")

class ConstantTerm 
  constructor : (@name) ->
    @_type = "ConstantTerm"

  get_hash : () ->
    return "#{@name}"

  toString : () ->
    return "#{@name}"

class VariableTerm 
  constructor : (@name) ->
    @name = @name.replace("?","")
    @_type = "VariableTerm"

  get_hash : () ->
    return "?"

  toString : () ->
    return "?#{@name}"

class RelationTerm 
  constructor : (@relation) ->
    @_type = "RelationTerm"

  get_hash : () ->
    return @relation.get_hash()

  toString : () ->
    return @relation.toString()

class RuleTerm 
  constructor : (@rule) ->
    @_type = "RuleTerm"

  get_hash : () ->
    return @rule.get_hash()

  toString : () ->
    return @rule.toString()

class Relation
  constructor : (@terms) ->
    # If the relation is part of a rule then this tells us which rule
    #
    @rule = null
    @hash = null

  # If the first term in a relation is a constant term then the relation is considered
  # named.
  #      
  is_named : (name) ->
    if @terms[0] instanceof ConstantTerm 
      if name?
        return @terms[0].name == name
      else
        return true
    
    return false 
  
  # If the relation is named then return its name; the value of the first term, if it is a 
  # constant term. If the relation is not named then throw an exception
  #  
  get_name : () ->
    if not @is_named()
      throw "Cannot retreive the name of a non named relation."

    return @terms[0].name  

  # Check the terms of types against the provided list of termtypes
  #
  has_signature : (types) ->
    if @terms.length != types.length 
      return false

    term_index = 0      
    for type in types
      if @terms[term_index] not instanceof type
        return false
      term_index += 1

    return true

  # Sets the rule to which this relation belongs
  #
  set_rule : (@rule) ->
    for term in @terms
      if term instanceof RelationTerm
        term.relation.set_rule(@rule) 

  # Returns true of the relation is part of a rule
  #      
  is_part_of_rule : () ->
    return @rule != null

  # Returns true if all the terms in the relation is constant and any terms that are relations
  # are also constants
  # TODO : This is constant and can be done in the constructor. Refcator later.
  is_constant : () ->
    for term in @terms
      if term instanceof RelationTerm
        if not term.relation.is_constant()
          return false
      else if term instanceof ConstantTerm
      else 
        # Any terms other than Constant or Relation will prompt a false
        return false

    return true 
 
  set_hash : (@hash) ->    

  # Get the unique? hash for this relation
  #
  get_hash : () ->
    if @hash? 
      return @hash
    
    if @terms.length >0
      terms_str = []
      for term in @terms
        terms_str.push(term.get_hash())
      @set_hash "#{terms_str.join('')}"
    else
      @set_hash = ""

    return @hash 

  # Return true if it can be calculated. Any embedded relations are also evaluated with the same ranges?
  # The rules is roughly outlined below
  #    (cell 1 1) eval with input (cel 1 2)    
  #    (next x (move ?x ?y))
  evaluate : (input,ranges,functions) ->






  toString : () ->
    if @terms.length >0
      terms_str = []
      for term in @terms
        terms_str.push(term.toString())
      return "(#{terms_str.join(' ')})"
    else
      return "()"

class Rule
  constructor : (head,body) ->
    @_type = "Rule"

    # If the head term is a constant term then rewrite it to be a relation
    #
    if head instanceof ConstantTerm
      @head = new RelationTerm(new Relation([head]))
    else
      @head = head  

    # Rewrite all the terms to be relations if they are constants
    #  
    @body = []  
    for term in body
      if term instanceof ConstantTerm
        @body.push new RelationTerm(new Relation([term]))
      else
        @body.push term

    # Set the parent rule for all the relations
    #
    @head.relation.set_rule(@)
    for term in @body 
      term.relation.set_rule(@)


  # Evaluate this rule based on the input values
  # values : array of values to use for the variable terms
  # ranges : ranges of cerain variables defined as constants 
  #
  evaluate : (values,ranges) -> 
    variables = {}
    value_index = 0
    # This needs to be recursive to handle embedded relations
    for index in _.range(1,@head.terms.length)
      if @head.terms[index] instanceof VariableTerm
        variables[@head.terms[index].name] = values[value_index]
        value_index += 1   

    for term in @terms
      term.evaluate(variables,ranges)    



  toString : () ->
    body_terms_str = []
    for body_term in @body
      body_terms_str.push(body_term.toString())
    return "(<= #{@head.toString()} #{body_terms_str.join(' ')})"


module.exports = 
  ConstantTerm : ConstantTerm
  VariableTerm : VariableTerm
  RelationTerm : RelationTerm
  RuleTerm : RuleTerm

  Relation : Relation

  Rule : Rule