should = require('chai').should()
expect = require('chai').expect

parser = require("../grammar/grammar_parser").parser;
parser.yy = require('../grammar/grammar_classes')

tests = [
  "(A B)"
  "(A (B C D) E (X Y Z) G)"
  "(A (B (X) D (<= (true x) (NOT (x))) ) X)"
  "(A (A NOOP))"
  "(A (B NOOP) C)"
  "(A (B (X X) NOOP) C)"
  "(A (B (X X (Y)) NOOP) C)"
    

  "(info)"
  "(START Match.12 ( (<= (TRUE (cell?x)) (false ?X)) ) 10 20)"
  "(START Match.12 ((cell 1 2) NOOP) 10 20)"

  "(role X)"
]

describe 'movement', () ->

  describe 'movement.update',() ->
    it 'should parse the empty program', () ->
      for test in tests
        console.log(test);
        #console.log("---------");
        pt = parser.parse(test);
        console.log(pt)
        console.log("=========");


    
  