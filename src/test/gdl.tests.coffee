should = require('chai').should()
expect = require('chai').expect

_ = require('underscore')

fs = require('fs')

parser = require('../grammar/parser')

test = (filename,done,cb) ->
  it "should parse the definition of #{filename}", (done) ->
    fs.readFile "./definitions/#{filename}",'utf8', (err,data) ->

      context = parser.parse(data);
      cb(context)

      done()


describe 'GDLContext', (done) ->
  test 'eight_puzzle.kif',done,(ctx) ->
    console.log ctx.toString()

describe 'GDLContext', (done) ->
  test 'tic-tac-toe.kif',done,(ctx) ->
    console.log ctx.toString()

describe 'GDLContext', (done) ->
  test 'three-player-tic-tac-chess.kif',done,(ctx) ->
    console.log ctx.toString()


###
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





    
    


    
  