_ = require("underscore")

class ConstantTerm 
  constructor : (@name) ->

  get_hash : () ->
    return "#{@name}"

  clone : () ->
    return new ConstantTerm(@name)

  toString : () ->
    return "#{@name}"

class VariableTerm 
  constructor : (@name) ->
    @name = @name.replace("?","")

  get_hash : () ->
    return "?#{@name}"

  clone : () ->
    return new VariableTerm(@name)

  toString : () ->
    return "?#{@name}"

class RelationTerm 
  constructor : (@relation) ->

  get_hash : () ->
    return @relation.get_hash()

  expand : (ranges) ->
    return @relation.expand(ranges)

  clone : () ->
    return new RelationTerm(@relation.clone())

  produces : (target) ->
    return @relation.produces(target)

  get_variables : () ->
    return @relation.get_variables()

  toString : () ->
    return @relation.toString()

class RuleTerm 
  constructor : (@rule) ->

  get_hash : () ->
    return @rule.get_hash()

  expand : (ranges) ->
    return @rule.expand(ranges)

  get_variables : () ->
    return @rule.get_variables()

  toString : () ->
    return @rule.toString()


module.exports =
  ConstantTerm : ConstantTerm
  VariableTerm : VariableTerm
  RelationTerm : RelationTerm
  RuleTerm : RuleTerm