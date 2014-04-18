class Program
  constructor : (@statements) ->
    @type = "Program"
    console.log "Program : constructed ... "

class ObjectConstant
  constructor : (name) ->
    @type = "ObjectConstant"
    @name = name.toLowerCase()
    console.log "ObjectConstant : #{@name} constructed ... "


class FunctionConstant
  constructor : (name) ->
    @type = "FunctionConstant"
    @name = name.toLowerCase()
    console.log "FunctionConstant : #{@name} constructed ... "

class Relation
  constructor : (name,@parms) ->
    @type = "Relation"
    @name = name.toLowerCase()
    @negate = false
    console.log "RelationConstant : #{@name} constructed ... "

  negate : () ->
    @negate = not @nagate

class Variable
  constructor : (name) ->
    @type = "Variable"
    @name = name.toLowerCase()
    console.log "Variable : #{@name} constructed ... "



module.exports = 
  Program : Program
  ObjectConstant : ObjectConstant
  FunctionConstant : FunctionConstant
  Relation : Relation
  Variable : Variable