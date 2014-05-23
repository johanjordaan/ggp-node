_ = require("underscore")

terms = require('./terms')
Relation = require('./relation').Relation
State = require('./state').State

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
    @goal_relations = []
    @terminal_relations = []
    @next_relations = []
    @role_relations = []
    @input_relations = []


    #@relation_hash_expansion = {} # Contains a hash and a array of expansions, eg { '(cell ?x)' : [0,1] }
    #@trancient_relations = []     # These relations will be killed on the next 'step'
    #@next_relations = []          # These relations will be moved  to transient after after the next step


  add_relation : (relation) ->
    # Add the relation to main list and lookup
    #
    @relations.push(relation)
    relation.set_context_index(@relations.length-1)
    @relation_hash_lookup[relation.get_hash()] = relation.get_context_index()
    
    #console.log '<><><>',relation.get_context_index(),relation.toString(),relation.is_constant()
    # If it is a constant relation then add it to the constant list
    #
    if relation.is_constant()
      @constant_relations.push(relation.get_context_index())
      # Ask each variable relation if it produces the new relation
      #
      #console.log '<><><>',_.keys(@variable_relations).length
      for index in @variable_relations
        variable_relation = @relations[index]
        #console.log '}}}',variable_relation.toString(),index,variable_relation instanceof Relation
        #if variable_relation not instanceof Relation
        #  console.log 'WTF : ',variable_relation
        if variable_relation.produces(relation)  
          @productions[index].push(relation.get_context_index())
    else
      @variable_relations.push(relation.get_context_index())
      @productions[relation.get_context_index()] = []
      # Ask this relation if it procides any of the constant relations
      #
      for index in @constant_relations
        constant_relation = @relations[index]
        #console.log '}}}',constant_relation,index,constant_relation instanceof Relation
        #if constant_relation not instanceof Relation
        #  console.log 'WTF : ',constant_relation
        if relation.produces(constant_relation)
          @productions[relation.get_context_index()].push(index)

  _find_or_create_relation : (rel_terms) ->
    new_relation = new Relation(rel_terms)
    existing_relation = @lookup_relation_by_hash(new_relation.get_hash())
    if existing_relation?
      return { existing:true, relation:existing_relation }

    return { existing:false, relation:new_relation }


  # If the relation already exists then discard it and return the existing one
  #
  create_relation : (rel_terms) ->
    #console.log '<><>',terms

    if not _.isArray(rel_terms)
      throw 'Terms need to be an array of terms. Parser issue?'

    # Do the special GDL pre-processing
    #  
    if rel_terms[0] instanceof terms.ConstantTerm 
      if rel_terms[0].name == 'init'
        @init_relations.push(rel_terms[1].relation.get_context_index())
        return rel_terms[1].relation 
      else if rel_terms[0].name == 'true'
        true_relation = rel_terms[1] 
        if true_relation not instanceof terms.RelationTerm
          true_relation = @create_relation([true_relation])
        return true_relation
      else if rel_terms[0].name == 'base'
        base_relation = rel_terms[1] 
        if base_relation not instanceof terms.RelationTerm
          base_relation = @create_relation([base_relation])
        @base_relations.push(base_relation.get_context_index())
        return base_relation
      else if rel_terms[0].name == 'does'
        rel_terms[0] = new terms.ConstantTerm('input')  
      else if rel_terms[0].name == 'not'
        not_relation = rel_terms[1] 
        if not_relation not instanceof terms.RelationTerm
          not_relation = @create_relation([not_relation])
        rel_terms[1] = not_relation


    # Create the relation based on the terms
    # If it exists then discard it and return the existing one
    #
    search_result = @_find_or_create_relation(rel_terms)
    if search_result.existing
      return search_result.relation
           
    @add_relation(search_result.relation)


    # Do the special GDL post-processing
    #  
    if rel_terms[0] instanceof terms.ConstantTerm 
      if rel_terms[0].name == 'legal'
        @legal_relations.push(search_result.relation.get_context_index())
      if rel_terms[0].name == 'goal'
        @goal_relations.push(search_result.relation.get_context_index())
      if rel_terms[0].name == 'terminal'
        @terminal_relations.push(search_result.relation.get_context_index())
      if rel_terms[0].name == 'next'
        @next_relations.push(search_result.relation.get_context_index())
      if rel_terms[0].name == 'role' 
        if search_result.relation.is_constant()
          @role_relations.push(search_result.relation.get_context_index())
      if rel_terms[0].name == 'input'
        @input_relations.push(search_result.relation.get_context_index())


    return search_result.relation

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

    #console.log '=====',new_body  
    new_dependents = []  
    for term in new_body
      #console.log '>>>',term
      #console.log '////',term.get_hash()
      term_index = @relation_hash_lookup[term.get_hash()]
      #console.log '_____',term_index
      new_dependents.push(term_index)

    @dependants[new_head_index].push new_dependents

    # TODO : Not required ?, Dependancy chains's define rules fully?
    # 
    @rules.push new_head    

    return new_head
  

  # Current state is the last state retrieved from this call IE the current state
  # If current state is null or not defined then the initial state will be returned
  # Transaitions is the moves in order of the definition of the roles
  #  
  get_state : (current_state,transitions) ->
    next_state = new State(@)

    # If the current state is not defined then assume we need to return the initial state
    #
    if !current_state?
      for init_relation_index in @init_relations  
        next_state.add_relation init_relation_index
    else

    return next_state

  #  
  evaluate : (relation_index) ->
    if relation_index in @constant_relations
      return true

    return false    



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
    ret_val += "Goal Relations     : [#{@goal_relations.length}]\n"
    ret_val += "Terminal Relations : [#{@terminal_relations.length}]\n"
    ret_val += "Next Relations     : [#{@next_relations.length}]\n"
    ret_val += "Role Relations     : [#{@role_relations.length}]\n"
    ret_val += "Input Relations    : [#{@input_relations.length}]\n"



    if verbose? and verbose
      ret_val += "\n"
      i = 0
      for relation in @relations    
        ret_val += "#{i}:#{relation.toString()}\n"
        i += 1 
    
    return ret_val


module.exports = 
  Context : Context
