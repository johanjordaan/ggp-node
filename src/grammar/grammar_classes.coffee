_ = require("underscore")

class ConstantTerm 
  constructor : (@name) ->
    @_type = "ConstantTerm"

  toString : () ->
    return "#{@name}"

class VariableTerm 
  constructor : (@name) ->
    @name = @name.replace("?","")
    @_type = "VariableTerm"

  toString : () ->
    return "?#{@name}"

class RelationTerm 
  constructor : (@relation) ->
    @_type = "RelationTerm"

  toString : () ->
    return @relation.toString()

class RuleTerm 
  constructor : (@rule) ->
    @_type = "RuleTerm"

  toString : () ->
    return @rule.toString()

class Relation
  constructor : (@terms) ->
    # If the relation is part of a rule then this tells us which rule
    #
    @rule = null

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
    #for term in @terms
    #  if term instanceof RelationTerm
    #    console.log '----',term
    #    term.relation.set_rule(@rule) 


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

    # Rewrite all the terms to be relations
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