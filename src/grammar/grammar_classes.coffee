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
  constructor : (@name,@terms) ->
    @_type = "Relation"

  toString : () ->
    if @terms.length >0
      terms_str = []
      for term in @terms
        terms_str.push(term.toString())
      return "(#{@name} #{terms_str.join(' ')})"
    else
      return "(#{@name})"

class ListRelation
  constructor : (@terms) ->
    @_type = "ListRelation"

  toString : () ->
    if @terms.length >0
      terms_str = []
      for term in @terms
        terms_str.push(term.toString())
      return "(#{terms_str.join(' ')})"
    else
      return "()"        

class Rule
  constructor : (@head,@body) ->
    @_type = "Rule"

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
  ListRelation : ListRelation

  Rule : Rule