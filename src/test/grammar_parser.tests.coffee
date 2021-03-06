###
should = require('chai').should()
expect = require('chai').expect

parser = require('../grammar/parser')

commands = require('../grammar/commands')

tests = [
  "(A B)"
  "(A (B C D) E (X Y Z) G)"
  "(A (B (X) D (<= (true x) (NOT (x)))) X)"
  "(A (A NOOP))"
  "(A (B NOOP) C)"
  "(A (B (X X) NOOP) C)"
  "(A (B (X X (Y)) NOOP) C)"
    

  "(info)"
  "(START Match.12 ((<= (TRUE (cell ?x)) (false ?X))) 10 20)"
  "(START Match.12 ((cell 1 2) NOOP) 10 20)"

  "(name)"
  "(name a)"
  "(name ?a)"
  "(name ?a b)"
  "(name ?a (name2 c) b)"
  "(info)"
  "(start MATCH ((role x) (role o)) 10 20)"
  "(play MATCH (NOOP (cell 1 2) NOOP))"
  "(name ((name 1 2) NOOP))"
  "( <= (cel ?x ?y) (move ?x ?y))"
  "( <= (cel ?x ?y) (move ?x ?y))"
  "( <= ( goal player 100 ) inorder ( true ( step 30 ) ) )"

  #";;;;;;;;; Hallo (role x)\n"

  
   
]



describe 'parse', () ->
  for test in tests
    x = (test) ->
      it 'should parse : '+test, () ->
        pt = parser.parse(test);
        pt.should.equal true
        test_res = parser.yy.program[0].toString()
        #test.should.equal test_res
    x(test)    

describe 'commands', () ->
    it 'should build the info command', () ->
      pt = parser.parse('( INFO )');
      pt.should.equal true
      cmd = commands.construct(parser.yy.program[0])
      #console.log parser.yy.program
      #console.log cmd.toString()
      #console.log cmd.execute
      #  info : ()->
      #    return x = 
      #      status : 'available'
      #      name : 'node_player'

###
    
  