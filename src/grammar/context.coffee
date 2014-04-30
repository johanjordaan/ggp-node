_ = require("underscore")

Relation = require('./relation').Relation

class Context 
  constructor : () ->
    @relations = []
    @rules = []
    @relation_hash_lookup = {}    # Contains a hash and a index into relations


  # If the relation already exists then discard it and return the existing one
  #
  create_relation : (terms) ->
    new_relation = new Relation(@,terms)
    console.log new_relation
    existing_relation = @relation_hash_lookup[new_relation.get_hash()]
    if existing_relation?
      return existing_relation

    @relations.push(new_relation)
    @relation_hash_lookup[new_relation.get_hash()] = @relations.length-1
    return new_relation

  # Returns the relation or null if it cannot be found
  #  
  lookup_relation_by_hash : (hash) ->
    index = @relation_hash_lookup[hash]
    if index?
      return @relations[index]

    return null 

  # TODO : No test yet...  
  create_rule : (head,body) ->
    new_rule = new Rule(@,head,body)
    @rules.push(new_rule)
    return new_rule

module.exports = 
  Context : Context
