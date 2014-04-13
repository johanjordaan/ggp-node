class Program
  constructor : (@statements) ->
    @type = "Program"
    console.log "---->",@statements
    console.log "Program : constructed ... "


class ObjectConstant
  constructor : (@name) ->
    @type = "ObjectConstant"
    console.log "ObjectConstant : #{@name} constructed ... "


class FunctionConstant
  constructor : (@name) ->
    @type = "FunctionConstant"
    console.log "FunctionConstant : #{@name} constructed ... "

class Relation
  constructor : (@name,@parms) ->
    @type = "Relation"
    console.log "RelationConstant : #{@name} constructed ... "

class Variable
  constructor : (@name) ->
    @type = "Variable"
    console.log "Variable : #{@name} constructed ... "



module.exports = 
  Program : Program
  ObjectConstant : ObjectConstant
  FunctionConstant : FunctionConstant
  Relation : Relation
  Variable : Variable