
Context = require('../grammar/context').Context

parser = require('../grammar/grammar_parser').parser;
parser.yy.terms = require('../grammar/terms')

parse = (text) ->
  context = new Context()
  parser.yy.context = context
  parser.parse(text)
  return context

module.exports = 
  parse : parse