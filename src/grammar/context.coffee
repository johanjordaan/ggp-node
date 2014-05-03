_ = require("underscore")

terms = require('./terms')
Relation = require('./relation').Relation
Rule = require('./rule').Rule

# TODO : 
# 1) Instead of using lists and splice etc to maintan lists impliment a linked list scheme
#    should be much faster and memory efficient ?
# 2) Mark unsatisfied variable relations
# 3) Mark relations where there is a discrepancy? Is this required?
# 4) Impliment safety checks on rules?

class Context 
  constructor : () ->
    @relations = []
    @relation_hash_lookup = {}    # Contains a hash and a index into relations, eg { '(cell x)' : 0 }
    @constant_relations = []      # All relations that are constants array contains indexes into @relations
    @variable_relations = []      # All relations that are variable array contains indexes into @relations
    @productions = {}             # { <variable_relation_index> : [<constant_relation_index>,...] }

    @rules = []


    #@relation_hash_expansion = {} # Contains a hash and a array of expansions, eg { '(cell ?x)' : [0,1] }
    #@trancient_relations = []     # These relations will be killed on the next 'step'
    #@next_relations = []          # These relations will be moved  to transient after after the next step

  # If the relation already exists then discard it and return the existing one
  #
  create_relation : (terms) ->
    #console.log '<><>',terms

    if not _.isArray(terms)
      throw 'Terms need to be an array of terms. Parser issue?'

    # Create the relation based on the terms
    # If it exists then discard it and return the existing one
    #
    new_relation = new Relation(terms)
    existing_relation = @lookup_relation_by_hash(new_relation.get_hash())
    if existing_relation?
      return existing_relation


    # Add the relation to main list and lookup
    #
    new_relation_index = @relations.length  
    @relations.push(new_relation)
    @relation_hash_lookup[new_relation.get_hash()] = new_relation_index
    
    #console.log '<><><>',new_relation_index,new_relation.toString(),new_relation.is_constant()
    # If it is a constant relation then add it to the constant list
    #
    if new_relation.is_constant()
      @constant_relations.push(new_relation_index)
      # Ask each variable relation if it produces the new relation
      #
      #console.log '<><><>',_.keys(@variable_relations).length
      for index in @variable_relations
        variable_relation = @relations[index]
        #console.log '}}}',variable_relation.toString(),index,variable_relation instanceof Relation
        #if variable_relation not instanceof Relation
        #  console.log 'WTF : ',variable_relation
        if variable_relation.produces(new_relation)  
          @productions[index].push(new_relation_index)
    else
      @variable_relations.push(new_relation_index)
      @productions[new_relation_index] = []
      # Ask this relation if it procides any of the constant relations
      #
      for index in @constant_relations
        constant_relation = @relations[index]
        #console.log '}}}',constant_relation,index,constant_relation instanceof Relation
        #if constant_relation not instanceof Relation
        #  console.log 'WTF : ',constant_relation
        if new_relation.produces(constant_relation)
          @productions[new_relation_index].push(index)
  

    return new_relation

  # Returns the relation or null if it cannot be found
  #  
  lookup_relation_by_hash : (hash) ->
    index = @relation_hash_lookup[hash]
    if index?
      return @relations[index]

    return null 


  # Expands all the relations to the constants 
  #
  expand : () ->
    for relation in relations 
      if relation.is_constant() 
      else
        # lookup all constant relations with the same name 
        # each one that can be produced by the relation is added to this relations 
        # list

  #step : () ->
  #  for transient_relation in @transient_relations



  # TODO : No test yet...  
  create_rule : (head,body) ->
    # If any of the terms in the head or body are not relations by themselves then 
    # Wrap them in relation terms
    #
    #console.log '++++',head,'+=+',body
    #console.log "Creating rule..."
    if head not instanceof terms.RelationTerm
      #console.log 'Creating head :',head.toString()
      new_head = @create_relation([head])
    else 
      #console.log 'Pushing head :',head.toString()
      new_head = head  

    new_body = []
    for term in body
      if term not instanceof terms.RelationTerm
        #console.log 'Creating body term :',term.toString()
        new_body.push(@create_relation([term]))
      else
        #console.log 'Pushing body term :',term.toString()
        new_body.push(term)



    @rules.push new_head    

    return new_head
    #new_rule = new Rule(head,body)
    #@rules.push(new_rule)
    #return new_rule
    

  toString : () ->
    ret_val = "" 
    ret_val += "Relations          : [#{@relations.length}]\n"
    ret_val += "Rules              : [#{@rules.length}]\n"
    ret_val += "Constant Relations : [#{@constant_relations.length}]\n"
    ret_val += "Variable Relations : [#{@variable_relations.length}]\n"


module.exports = 
  Context : Context
