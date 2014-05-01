fs = require('fs')

should = require('chai').should()
expect = require('chai').expect

terms = require('../../grammar/terms') 
parser = require('../../grammar/parser')


it_should = (description,text,cb) ->
  it "should #{description}", () ->
    context = parser.parse(text);
    cb(context)

describe 'Relation', () ->

  describe '#get_name', () ->
    
    it_should 'return the name of a named relation', '(Named)', (context) ->
      context.lookup_relation_by_hash('Named').get_name().should.equal "Named"   
    
    it_should 'return null if the relation is not named', '((anon) Named)', (context) ->
      should.not.exist(context.lookup_relation_by_hash('anonNamed').get_name())


  describe '#has_signature', () ->
    
    it_should 'return true of the term types match the provided list of term types', '(cell ?x)' , (context) ->
      signature = [terms.ConstantTerm,terms.VariableTerm]
      context.lookup_relation_by_hash('cell?').has_signature(signature).should.equal true


    it_should 'return false if the number of terms are not the same as the list of types', '(cell ?x)', (context) ->
      context.lookup_relation_by_hash('cell?').has_signature([terms.ConstantTerm]).should.equal false
      context.lookup_relation_by_hash('cell?').has_signature([]).should.equal false
      signature = [terms.ConstantTerm,terms.ConstantTerm,terms.ConstantTerm]
      context.lookup_relation_by_hash('cell?').has_signature(signature).should.equal false

    it_should 'return false if the types provided do not match the types of the terms', '(cell ?x)', (context) ->
      signature = [terms.VariableTerm,terms.VariableTerm]
      context.lookup_relation_by_hash('cell?').has_signature(signature).should.equal false


  describe "#is_constant", () ->
    
    it_should 'return false if any of the terms in a relation is not constant', '(cell ?x)((cell ?x) x)', (context) ->
      context.lookup_relation_by_hash('cell?').is_constant().should.equal false
      context.lookup_relation_by_hash('cell?x').is_constant().should.equal false

    it_should 'should return true if all the terms of the relation is constant','(cell 1)(cell (cell x))' , (context) ->
      context.lookup_relation_by_hash('cell1').is_constant().should.equal true
      context.lookup_relation_by_hash('cellx').is_constant().should.equal true
      context.lookup_relation_by_hash('cellcellx').is_constant().should.equal true



  #describe "#clone", () ->
  #  it_should ''
#
#    it 'should create a clone of a relation recursively', () ->
#      context = parser.parse("(cell 1 (valid 2))");
#      orig = context.relations[1]
#      clone = orig.clone()
#      clone.get_hash().should.equal orig.get_hash()
#      clone.set_hash('xxx')
#      clone.get_hash().should.not.equal orig.get_hash()



###
describe 'Relation', () ->

  name_term = new gc.ConstantTerm("Named")
  other_term = new gc.VariableTerm("Variable")
  named_relation = new gc.Relation([name_term,other_term])
  anon_relation = new gc.Relation([named_relation])
  constant_relation = new gc.Relation([name_term,new gc.ConstantTerm("1"),new gc.ConstantTerm("2")])
  constant_relation_with_1_term = new gc.Relation([name_term])
  constant_relation_with_relation = new gc.Relation([name_term,new gc.ConstantTerm("1"),new gc.RelationTerm(constant_relation_with_1_term)])




  describe "#is_constant", () ->
    it 'should return false if any of the terms in a relation is not constant', () ->
      named_relation.is_constant().should.equal false
      anon_relation.is_constant().should.equal false

    it 'should return true if all the terms of the relation is constant', () ->
      constant_relation_with_1_term.is_constant().should.equal true
      constant_relation.is_constant().should.equal true

    it 'should return true if all the terms and the relations(recursively) are constant',() ->
      constant_relation_with_relation.is_constant().should.equal true  

  describe "#get_hash", () ->
    it 'should return the hash of the relation : Named12', () ->
      constant_relation.get_hash().should.equal "Named12"
    it 'should return the hash of the relation : Named1Named', () ->
      constant_relation_with_relation.get_hash().should.equal "Named1Named"
    it 'should return the hash of the relation : Named?', () ->
      named_relation.get_hash().should.equal "Named?"
    it 'should calculate the hash lazily', () ->
      constant_relation_with_relation.set_hash("xxx")
      constant_relation_with_relation.get_hash().should.equal "xxx"
###
###
describe 'Relation', () ->
  describe "#clone", () ->
    it 'should create a clone of a relation recursively', () ->
      context = parser.parse("(cell 1 (valid 2))");
      orig = context.relations[1]
      clone = orig.clone()
      clone.get_hash().should.equal orig.get_hash()
      clone.set_hash('xxx')
      clone.get_hash().should.not.equal orig.get_hash()
      

  describe "#expand", () ->
    it 'should expand constant relation to : [ (cell 1 2) ]', () ->
      ok = parser.parse("(cell 1 2)");
      ok.should.equal true    
      term_zero = parser.yy.program[0]
      domain = term_zero.expand() 
      domain.length.should.equal 1
      domain[0].get_hash().should.equal term_zero.get_hash()


    describe 'should expand relations with variable', () -> 
      it 'should expend to : [(succ 1 2)]', () ->  
        ok = parser.parse("(succ 1 2)(succ 2 3)(succ ?x 2)");
        ok.should.equal true    
        term_zero = parser.yy.program[2]
        domain = term_zero.expand({succ:[parser.yy.program[0],parser.yy.program[1]]}) 
        domain.length.should.equal 1

      it 'should expend to : [(succ 1 2)(succ 2 3)]', () ->  
        ok = parser.parse("(succ 1 2)(succ 2 3)(succ ?x ?y)");
        ok.should.equal true    
        term_zero = parser.yy.program[2]
        domain = term_zero.expand({succ:[parser.yy.program[0],parser.yy.program[1]]}) 
        domain.length.should.equal 2

      it 'should expend to : [(cell (index 1)) (cell (index 2))]', () ->  
        ok = parser.parse("(cell (index 1)) (cell (index 2)) (cell (index ?x))");
        ok.should.equal true    
        term_zero = parser.yy.program[2]

        domain = term_zero.expand({cell:[parser.yy.program[0],parser.yy.program[1]]}) 
        domain.length.should.equal 2

      it 'should expend to : [(cell (index 1)) (cell (index 2))]', () ->  
        ok = parser.parse("(cell (index 1)) (cell (index 2)) (cell ?x)");
        ok.should.equal true    
        term_zero = parser.yy.program[2]

        domain = term_zero.expand({cell:[parser.yy.program[0],parser.yy.program[1]]}) 
        domain.length.should.equal 2


  describe "#get_variables", () ->
    it 'should extract all the variables in the relation', () ->
      ok = parser.parse("(base (cell ?x ?y b) ?z)")
      ok.should.equal true

      relation = parser.yy.program[0]
      variables = relation.get_variables()
      variables.length.should.equal 3
      (variables[0] instanceof gc.VariableTerm).should.equal true
      variables[0].name.should.equal "x"
      (variables[1] instanceof gc.VariableTerm).should.equal true
      variables[1].name.should.equal "y"
      (variables[2] instanceof gc.VariableTerm).should.equal true
      variables[2].name.should.equal "z"


describe 'Rule', () ->
  describe '#get_variables', () ->
    it 'should extract the variables from the rule head',() ->
      ok = parser.parse("(<= (base (cell ?x ?y b)) (index ?x) (index ?y))")
      ok.should.equal true

      rule = parser.yy.program[0]
      
      variables = rule.get_variables()
      #variables.length.should.equal 2
      console.log variables
      #variables.x.length.should.equal 1
      #variables.x[0].should.equal "index"
      #variables.y.length.should.equal 1
      #variables.y[0].should.equal "index"



  describe '#expand', () ->
    it 'should expand the rule',() ->
      ok = parser.parse("(index 1) (index 2) (index 3) (<= (base (cell ?x ?y b)) (index ?x) (index ?y))")
      ok.should.equal true

      rule = parser.yy.program[3]
      ranges = { index : [parser.yy.program[0], parser.yy.program[1], parser.yy.program[2]] }

      domain = rule.expand(ranges)
      #console.log rule.toString()
###












  