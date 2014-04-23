_ = require("underscore")

class ConstantTerm 
  constructor : (@name) ->
    @type = "ConstantTerm"
    console.log "#{@type} : constructed ... #{@name}"

  toString : () ->
    return "#{@name}"

class VariableTerm 
  constructor : (@name) ->
    @name = @name.replace("?","")
    @type = "VariableTerm"
    console.log "#{@type} : constructed ... #{@name}"

  toString : () ->
    return "?#{@name}"

class RelationTerm 
  constructor : (@relation) ->
    @type = "RelationTerm"
    console.log "#{@type} : constructed ... #{@relation.name}"

  toString : () ->
    return @relation.toString()

class RuleTerm 
  constructor : (@rule) ->
    @type = "RuleTerm"
    console.log "#{@type} : constructed ... "

  toString : () ->
    return @rule.toString()

class Relation
  constructor : (@name,@terms) ->
    @type = "Relation"
    console.log "#{@type} : constructed ... #{@name}"

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
    @type = "ListRelation"
    console.log "#{@type} : constructed ... #{@toString()}"

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
    @type = "Rule"
    console.log "#{@type} : constructed ... "

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