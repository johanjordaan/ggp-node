should = require('chai').should()
expect = require('chai').expect

_ = require('underscore')

fs = require('fs')

parser = require('../grammar/grammar_parser').parser;
parser.yy = require('../grammar/grammar_classes') 

GDLContext = require('../grammar/gdl').GDLContext

test = (filename,done,cb) ->
  it "should parse the definition of #{filename}", (done) ->
    fs.readFile "./definitions/tests/#{filename}",'utf8', (err,data) ->
      ok = parser.parse(data);
      ok.should.equal true
      root_relation = parser.yy.program
      cb(new GDLContext(root_relation))

      done()



describe 'GDLContext', (done) ->
  test 'empty.kif',done,(ctx) ->
    console.log ctx.toString()

  test 'roles.kif',done,(ctx) ->
    _.has(ctx.ranges,'role').should.equal true
    ctx.ranges.role.length.should.equal 2
    ctx.ranges.role[0].should.equal 'xplayer'
    ctx.ranges.role[1].should.equal 'oplayer'



    
  