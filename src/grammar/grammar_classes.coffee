_ = require("underscore")

class ConstantTerm 
  constructor : (@name) ->
    @type = "ConstantTerm"
    console.log "#{@type} : constructed ... #{@name}"

  as_str : () ->
    return "#{@name}"

class VariableTerm 
  constructor : (@name) ->
    @name = @name.replace("?","")
    @type = "VariableTerm"
    console.log "#{@type} : constructed ... #{@name}"

  as_str : () ->
    return "?#{@name}"

class RelationTerm 
  constructor : (@relation) ->
    @type = "RelationTerm"
    console.log "#{@type} : constructed ... #{@relation.name}"

  as_str : () ->
    return @relation.as_str()

class RuleTerm 
  constructor : (@rule) ->
    @type = "RuleTerm"
    console.log "#{@type} : constructed ... "

  as_str : () ->
    return @rule.as_str()

class CommandRelation
  constructor : (@name,@terms) ->
    @type = "CommandRelation"
    console.log "#{@type} : constructed ... #{@name}"

  as_str : () ->
    terms_str = []
    for term in @terms
      terms_str.push(term.as_str())
    return "(#{@name} #{terms_str.join(' ')})"

class GDLRelation
  constructor : (@name,@terms) ->
    @type = "GDLRelation"
    console.log "#{@type} : constructed ... #{@name}"

  as_str : () ->
    terms_str = []
    for term in @terms
      terms_str.push(term.as_str())
    return "(#{@name} #{terms_str.join(' ')})"

class LogicRelation
  constructor : (@name,@terms) ->
    @type = "LogicRelation"
    console.log "#{@type} : constructed ... #{@name}"

  as_str : () ->
    terms_str = []
    for term in @terms
      terms_str.push(term.as_str())
    return "(#{@name} #{terms_str.join(' ')})"

class AnonymousRelation
  constructor : (@name,@terms) ->
    @type = "AnonymousRelation"
    console.log "#{@type} : constructed ... #{@name}"

  as_str : () ->
    terms_str = []
    for term in @terms
      terms_str.push(term.as_str())
    return "(#{@name} #{terms_str.join(' ')})"

class ListRelation
  constructor : (@terms) ->
    @type = "ListRelation"
    console.log "#{@type} : constructed ... #{@as_str()}"

  as_str : () ->
    terms_str = []
    for term in @terms
      terms_str.push(term.as_str())
    return "(#{terms_str.join(' ')})"



class Rule
  constructor : (@head,@body) ->
    @type = "Rule"
    console.log "#{@type} : constructed ... "

  as_str : () ->
    body_terms_str = []
    for body_term in @body
      body_terms_str.push(body_term.as_str())
    return "(<= #{@head.as_str()} #{body_terms_str.join(' ')})"


module.exports = 
  ConstantTerm : ConstantTerm
  VariableTerm : VariableTerm
  RelationTerm : RelationTerm
  RuleTerm : RuleTerm

  CommandRelation : CommandRelation
  GDLRelation : GDLRelation
  LogicRelation : LogicRelation
  AnonymousRelation : AnonymousRelation
  ListRelation : ListRelation

  Rule : Rule