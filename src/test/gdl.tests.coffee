###
should = require('chai').should()
expect = require('chai').expect

_ = require('underscore')

fs = require('fs')

gc = require('../grammar/grammar_classes') 

Parser = require('../grammar/parser').Parser
parser = new Parser()

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

  test 'constants.kif',done,(ctx) ->
    _.has(ctx.ranges,'role').should.equal true
    ctx.ranges.role.length.should.equal 2
    ctx.ranges.role[0].should.equal 'x'
    ctx.ranges.role[1].should.equal 'y'

    _.has(ctx.ranges,'index').should.equal true
    ctx.ranges.index.length.should.equal 3
    ctx.ranges.index[0].should.equal 1
    ctx.ranges.index[1].should.equal 2
    ctx.ranges.index[2].should.equal 3

    #_.has(ctx.ranges,'succ').should.equal true
    #console.log ctx.ranges
    #ctx.ranges.index.length.should.equal 2
###





    
    


    
  