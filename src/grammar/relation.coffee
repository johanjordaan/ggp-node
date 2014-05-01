_ = require("underscore")

terms  = require('../grammar/terms')

class Relation
  constructor : (@context,@terms) ->
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

  # Return the expanded version of this relation given the ranges
  #
  expand : (ranges) ->
    # Constant relations expand to themselves (clone)
    #
    if @is_constant()
      return [@clone()]

    # ------ Experimental  
    # Get the name and range of the relation
    #
    name = @get_name()
    if not _.has(ranges,name)
      return []
    range = ranges[name]  

    # 
    #  TODO : What about relation terms
    domain  = []
    for range_relation in range
      if @produces(range_relation)
        domain.push(range_relation.clone())
     
    return domain        

  # Deep clone a relation 
  # TODO : What about the other fields like rule etc ?
  clone : () ->
    cloned_terms = []
    for term in @terms
      cloned_terms.push(term.clone())
    return new Relation(null,cloned_terms) 


  # Returns true if this relation can produce the target
  # (succ ?x ?y) produces to any relations (succ 1 2) (succ 2 3)
  # (succ 1 2) only produces to (succ 1 2)
  # (succ ?x 2) only produces to (succ 1 2) (succ 2 2) 
  # (succ ?x (index 2)) will produces to any value of x given index conforming to 2 ???
  # Target is a relation and it should have only constant terms?
  #
  produces : (target) ->
    if target.relation.terms.length != @terms.length
      return false

    # TODO : This rule might change?  
    if not target.relation.is_constant()   
      return false

    for index in _.range(@terms.length)
      if @terms[index] instanceof terms.ConstantTerm
        if @terms[index].name != target.relation.terms[index].name  
          return false

      if @terms[index] instanceof terms.RelationTerm
        if not @terms[index].relation.produces(target.relation.terms[index])
          return false
                
    return true      




  # Return true if it can be calculated. Any embedded relations are also evaluated with the same ranges?
  # The rules is roughly outlined below
  #    (cell 1 1) eval with input (cel 1 2)    
  #    (next x (move ?x ?y))
  evaluate : (input,ranges,functions) ->


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