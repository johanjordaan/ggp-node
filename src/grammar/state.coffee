_ = require("underscore")

class State
  constructor : (@context) ->
    @relation_indexes  = []

  add_relation : (relation_index) ->
    @relation_indexes.push(relation_index)

  get_legal_moves : () ->
      

  toString : () ->
    ret_val = ""
    for relation_index in @relation_indexes
      ret_val += "#{@context.relations[relation_index].toString()}\n"
    return ret_val

module.exports = 
  State : State

