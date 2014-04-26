should = require('chai').should()
expect = require('chai').expect


fs = require('fs')

parser = require('../grammar/grammar_parser').parser;
parser.yy = require('../grammar/grammar_classes') 

GDLContext = require('../grammar/gdl').GDLContext

describe 'handle roles', () ->
  it 'should parse the definition of tic-tac-toe', (done) ->
    
    fs.readFile './tic-tac-toe.kif','utf8', (err,data) ->
      ok = parser.parse(data);
      ok.should.equal true
      root_relation = parser.yy.program

      gdl_ctx = new GDLContext(root_relation)

      #gdl_ctx.roles.length.should.equal 2
      console.log gdl_ctx.roles 
      console.log gdl_ctx.constant_relation_names

      done()


    
  