_ = require("underscore")

terms  = require('../grammar/terms')


# Some 'rules' : Relations no nothing about its context or its relationship with other relations
# this is the job of the context.
# Relation can tell you about their own internals.
#
class Relation
  constructor : (@terms) ->
    @hash = null
    @is_named_ind = null
    @name = null
    @is_constant_ind = null
  
  # If the relation is named then return its name; the value of the first term, if it is a 
  # constant term. If the relation is not named then return null
  #  
  get_name : () ->
    if @is_named_ind?
      return @name

    if @terms[0] instanceof terms.ConstantTerm 
      @is_named_ind = true
      @name = @terms[0].name  
      return @name
    else
      @is_named_ind = true
      return @name

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

  # Returns true if all the terms in the relation is constant and any terms that are relations
  # are also constants
  #
  is_constant : () ->
    if @is_constant_ind?
      return @is_constant_ind

    for term in @terms
      if term instanceof terms.RelationTerm
        if not term.relation.is_constant()
          @is_constant_ind = false
          return @is_constant_ind
      else if term instanceof terms.ConstantTerm
      else 
        # Any terms other than Constant or Relation will prompt a false
        @is_constant_ind = false
        return @is_constant_ind

    @is_constant_ind = true
    return @is_constant_ind

  # Get the unique? hash for this relation
  #
  get_hash : () ->
    if @hash? 
      return @hash
    
    if @terms.length >0
      terms_str = []
      for term in @terms
        terms_str.push(term.get_hash())
      @hash = "(#{terms_str.join(' ')})"
    else
      @hash = "()"

    return @hash 

  # Returns true if this relation can produce the target
  # (succ ?x ?y) produces to any relations (succ 1 2) (succ 2 3)
  # (succ 1 2) only produces to (succ 1 2)
  # (succ ?x 2) only produces to (succ 1 2) (succ 2 2) 
  # (succ ?x (index 2)) will produces to any value of x given index conforming to 2 ???
  # Target is a relation and it should have only constant terms?
  #  Target is NOT a TERM
  produces : (target) ->
    #console.log '===>',@terms,'>>>',target
    if target.terms.length != @terms.length
      return false

    # TODO : This rule might change?  
    if not target.is_constant()   
      return false

    for index in _.range(@terms.length)
      if @terms[index] instanceof terms.ConstantTerm
        if @terms[index].name != target.terms[index].name  
          return false

      if @terms[index] instanceof terms.RelationTerm
        if target.terms[index] instanceof terms.RelationTerm
          if not @terms[index].relation.produces(target.terms[index].relation)
            return false
        else  
          #console.log '===>',@terms,'>>>',target
          #console.log 'xxxx> ',target.terms[index]
          #if not @terms[index].relation.produces(target.terms[index])
          return false
                
    return true      


  # TODO : Should be done lazily  
  # returns a list of Variable Terms ... These terms are not all on the same level
  get_variables : () ->
    variables = []
    for term in @terms
      if term instanceof terms.VariableTerm
        if term.name in variables
        else
          variables.push(term)
      if term instanceof terms.RelationTerm
        variables = variables.concat(term.get_variables())

    return variables



  toString : () ->
    if @terms.length >0
      terms_str = []
      for term in @terms
        terms_str.push(term.toString())
      return "(#{terms_str.join(' ')})"
    else
      return "()"

module.exports =
  Relation : Relation