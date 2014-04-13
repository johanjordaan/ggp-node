should = require('chai').should()
expect = require('chai').expect

fs = require("fs")
PEG = require("pegjs")
gdlparser = require("../ast/gdl_parser.js")

tests = [
  "(role x)(role o) (role judge) "
  #"(role ?x)"
  #"(role z s)"
  #"(role (player a))"
#  "(role x y  z)"
#  "( role x ?y)"
#  "(p a ?y)"
#  "(not (p a ?y))"
#  "(<= (base (moveCount ?m)) (scoreMap ?m ?n))"
#  "(<= (base (cell ?m ?n ?p)) (col ?m) (row ?n) (piece ?p))"
#  "(plus 1 count  0  1)"
#  ";Hallo\n(role x)"
]
describe 'movement', () ->

  describe 'movement.update',() ->
    it 'should parse the empty program', () ->
      for test in tests
        console.log(test);
        #console.log("---------");
        pt = gdlparser.parse(test);
        #console.log(pt)
        console.log("=========");


    
  