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
      context.lookup_relation_by_hash('(Named)').get_name().should.equal "Named"   
    
    it_should 'return null if the relation is not named', '((anon) Named)', (context) ->
      should.not.exist(context.lookup_relation_by_hash('((anon) Named)').get_name())


  describe '#has_signature', () ->
    
    it_should 'return true of the term types match the provided list of term types', '(cell ?x)' , (context) ->
      signature = [terms.ConstantTerm,terms.VariableTerm]
      context.lookup_relation_by_hash('(cell ?x)').has_signature(signature).should.equal true


    it_should 'return false if the number of terms are not the same as the list of types', '(cell ?x)', (context) ->
      context.lookup_relation_by_hash('(cell ?x)').has_signature([terms.ConstantTerm]).should.equal false
      context.lookup_relation_by_hash('(cell ?x)').has_signature([]).should.equal false
      signature = [terms.ConstantTerm,terms.ConstantTerm,terms.ConstantTerm]
      context.lookup_relation_by_hash('(cell ?x)').has_signature(signature).should.equal false

    it_should 'return false if the types provided do not match the types of the terms', '(cell ?x)', (context) ->
      signature = [terms.VariableTerm,terms.VariableTerm]
      context.lookup_relation_by_hash('(cell ?x)').has_signature(signature).should.equal false


  describe "#is_constant", () ->
    
    it_should 'return false if any of the terms in a relation is not constant', '(cell ?x)((cell ?x) x)', (context) ->
      context.lookup_relation_by_hash('(cell ?x)').is_constant().should.equal false
      context.lookup_relation_by_hash('((cell ?x) x)').is_constant().should.equal false

    it_should 'should return true if all the terms of the relation is constant','(cell 1)(cell (cell x))' , (context) ->
      context.lookup_relation_by_hash('(cell 1)').is_constant().should.equal true
      context.lookup_relation_by_hash('(cell x)').is_constant().should.equal true
      context.lookup_relation_by_hash('(cell (cell x))').is_constant().should.equal true

  describe "#get_hash", () ->
    
    it_should 'should return the hash of the relation', '(Named 1 2)(Named 1 (Named))(Named ?x)', (context) ->
      context.lookup_relation_by_hash('(Named 1 2)').get_hash().should.equal '(Named 1 2)'
      context.lookup_relation_by_hash('(Named 1 (Named))').get_hash().should.equal '(Named 1 (Named))'
      context.lookup_relation_by_hash('(Named ?x)').get_hash().should.equal '(Named ?x)'
   
   it_should 'should calculate the hash lazily', '(Named 1)(Named ?x)(Named 2)', (context) ->
      context.lookup_relation_by_hash('(Named 1)').hash =  'xxx'
      context.lookup_relation_by_hash('(Named 1)').get_hash().should.equal 'xxx'











  