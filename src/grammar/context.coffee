_ = require("underscore")

terms = require('./terms')
Relation = require('./relation').Relation

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
    @dependants = {}              # { relation_index : [ [<relation index>],[] ] }

    @rules = []

    @init_relations = []
    @base_relations = []
    @legal_relations = []


    #@relation_hash_expansion = {} # Contains a hash and a array of expansions, eg { '(cell ?x)' : [0,1] }
    #@trancient_relations = []     # These relations will be killed on the next 'step'
    #@next_relations = []          # These relations will be moved  to transient after after the next step

  # If the relation already exists then discard it and return the existing one
  #
  create_relation : (rel_terms) ->
    #console.log '<><>',terms

    if not _.isArray(rel_terms)
      throw 'Terms need to be an array of terms. Parser issue?'


    # Create the relation based on the terms
    # If it exists then discard it and return the existing one
    #
    new_relation = new Relation(rel_terms,@relations.length)
    existing_relation = @lookup_relation_by_hash(new_relation.get_hash())
    if existing_relation?
      return existing_relation


    # Do the special GDL processing
    #  
    if rel_terms[0] instanceof terms.ConstantTerm 
      if rel_terms[0].name == 'init'
        @init_relations.push(rel_terms[1].relation.context_index)
        return rel_terms[1].relation 
      if rel_terms[0].name == 'true'
        return rel_terms[1].relation
      if rel_terms[0].name == 'base'
        @base_relations.push(rel_terms[1].relation.context_index)
        return rel_terms[1].relation
      if rel_terms[0].name == 'legal'
        # If the 2de term is not a relations then convert it to one
        #
        
        #new_relation = new Relation([rel_term[2]],@relations.length)
        #existing_relation = @lookup_relation_by_hash(new_relation.get_hash())  
        
        @legal_relations.push(rel_terms[2].relation.context_index)  




    # Add the relation to main list and lookup
    #
    @relations.push(new_relation)
    @relation_hash_lookup[new_relation.get_hash()] = new_relation.context_index
    
    #console.log '<><><>',new_relation.context_index,new_relation.toString(),new_relation.is_constant()
    # If it is a constant relation then add it to the constant list
    #
    if new_relation.is_constant()
      @constant_relations.push(new_relation.context_index)
      # Ask each variable relation if it produces the new relation
      #
      #console.log '<><><>',_.keys(@variable_relations).length
      for index in @variable_relations
        variable_relation = @relations[index]
        #console.log '}}}',variable_relation.toString(),index,variable_relation instanceof Relation
        #if variable_relation not instanceof Relation
        #  console.log 'WTF : ',variable_relation
        if variable_relation.produces(new_relation)  
          @productions[index].push(new_relation.context_index)
    else
      @variable_relations.push(new_relation.context_index)
      @productions[new_relation.context_index] = []
      # Ask this relation if it procides any of the constant relations
      #
      for index in @constant_relations
        constant_relation = @relations[index]
        #console.log '}}}',constant_relation,index,constant_relation instanceof Relation
        #if constant_relation not instanceof Relation
        #  console.log 'WTF : ',constant_relation
        if new_relation.produces(constant_relation)
          @productions[new_relation.context_index].push(index)
  




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

    # Now build the array of dependants
    #    
    new_head_index = @relation_hash_lookup[new_head.get_hash()]   

    if not _.has(@dependants,new_head_index)    
      @dependants[new_head_index] = []
    else
      #console.log '--->',new_head.toString()
      # TODO : This might be an error case ? Or do we just ad the dependnats ?
      # If it has been found then just 

    new_dependents = []  
    for term in new_body
      term_index = @relation_hash_lookup[term.get_hash()]
      new_dependents.push(term_index)

    @dependants[new_head_index].push new_dependents

    # TODO : Not required ?, Dependancy chains's define rules fully?
    # 
    @rules.push new_head    

    return new_head
    

  toString : (verbose) ->
    ret_val = "" 
    ret_val += "Relations          : [#{@relations.length}]\n"
    ret_val += "Rules              : [#{@rules.length}]\n"
    ret_val += "Constant Relations : [#{@constant_relations.length}]\n"
    ret_val += "Variable Relations : [#{@variable_relations.length}]\n"
    ret_val += "Dependancy Chains  : [#{_.keys(@dependants).length}]\n"
    ret_val += "Init Relations     : [#{@init_relations.length}]\n"
    ret_val += "Base Relations     : [#{@base_relations.length}]\n"
    ret_val += "Legal Relations    : [#{@legal_relations.length}]\n"
    if verbose? and verbose
      ret_val += "\n"
      for relation in @relations    
        ret_val += "#{relation.toString()}\n" 
    
    return ret_val


module.exports = 
  Context : Context
