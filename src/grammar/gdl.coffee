_ = require('underscore')

gc = require('./grammar_classes')

class GDLContext
  constructor : (definition) ->
    @roles = []
    @inits = []
    @bases = []

    @ranges = { }

    @relations = []


    if _.isArray(definition)
      for term in definition
        @handle_term(term)
    else
      @handle_term(definition)    


  handle_term : (term,parent) ->
    if !term._type?
      throw 'Expected term got something else'

    if term._type == 'RelationTerm'
      @handle_relation(term.relation)  

    if term._type == 'RuleTerm'
      @handle_rule(term.rule) 


  handle_relation : (relation) ->  
    if not relation.is_part_of_rule()
      if relation.is_constant()
        # If the range does not exist yet then create it
        #
        if not _.has(@ranges,relation.terms[0].name)
          @ranges[relation.terms[0].name] = []

        # Set the values based on the 'rest' of the terms
        #  
        for index in _.range(1,relation.terms.length)
          @ranges[relation.terms[0].name].push relation.terms[index].name


      #if relation.is_named("role") and relation.has_signature([gc.ConstantTerm,gc.ConstantTerm])
      #  @roles.push relation
      #else if relation.is_named("init") and relation.has_signature([gc.ConstantTerm,gc.RelationTerm])
      #  @inits.push relation.terms[1]
      #else if relation.is_named("base")
      #  @bases.push relation.terms[1]
      #else
      #  @relations.push relation 
      #for term in relation.terms
      #  @handle_term(term,relation)     


  handle_rule : (rule) ->  
    @handle_term(rule.head)
    for term in rule.body
      @handle_term(term)


  toString : () ->
    roles_str = _.map(@roles,(r)->r.toString()).join(',')
    return roles_str





module.exports =
  GDLContext : GDLContext