_ = require("underscore")

terms  = require('../grammar/terms')

class Rule
  constructor : (head,body) ->
    # If the head term is a constant term then rewrite it to be a relation
    #
    if head instanceof terms.ConstantTerm
      @head = new RelationTerm(new Relation([head]))
    else
      @head = head  

    # Rewrite all the terms to be relations if they are constants
    #  
    @body = []  
    for term in body
      if term instanceof terms.ConstantTerm
        @body.push new RelationTerm(new Relation([term]))
      else
        @body.push term

  # Evaluate this rule based on the input values
  # values : array of values to use for the variable terms
  # ranges : ranges of cerain variables defined as constants 
  #
  evaluate : (values,ranges) -> 
    variables = {}
    value_index = 0
    # This needs to be recursive to handle embedded relations
    for index in _.range(1,@head.terms.length)
      if @head.terms[index] instanceof terms.VariableTerm
        variables[@head.terms[index].name] = values[value_index]
        value_index += 1   

    for term in @terms
      term.evaluate(variables,ranges)    

  expand : (ranges) ->
    
  # Extract the variables from the head and extract their range names as well based
  # on the body terms
  #    
  get_variables : () ->
    variables = {}

    head_variables = @head.get_variables()
    for variable in @head.get_variables()
      variables[variable.name] = []

    for term in @body
      term_variables = term.get_variables()
      for term_variable in term_variables
        if(_.has(variables,term_variable.name))
          variables[term_variable.name].push(term.relation.terms[0].name)


    return variables



  toString : () ->
    body_terms_str = []
    for body_term in @body
      body_terms_str.push(body_term.toString())
    return "(<= #{@head.toString()} #{body_terms_str.join(' ')})"

module.exports =
  Rule : Rule