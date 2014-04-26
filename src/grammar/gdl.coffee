_ = require('underscore')

gc = require('./grammar_classes')

class GDLContext
  constructor : (definition) ->
    @roles = []
    @constant_relations = []
    @constant_relation_names = []

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
    if relation.is_named("role") and relation.has_signature([gc.ConstantTerm,gc.ConstantTerm])
      @roles.push relation.terms[1].name


    for term in relation.terms
      @handle_term(term,relation)     


  handle_rule : (rule) ->  
    @handle_term(rule.head)
    for term in rule.body
      @handle_term(term)





module.exports =
  GDLContext : GDLContext