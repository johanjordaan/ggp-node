should = require('chai').should()
expect = require('chai').expect


fs = require('fs')

gc = require('../grammar/grammar_classes') 

describe 'Relation', () ->
  name_term = new gc.ConstantTerm("Named")
  other_term = new gc.VariableTerm("Variable")
  named_relation = new gc.Relation([name_term,other_term])
  anon_relation = new gc.Relation([named_relation])
  constant_relation = new gc.Relation([name_term,new gc.ConstantTerm("1"),new gc.ConstantTerm("2")])
  constant_relation_with_1_term = new gc.Relation([name_term])
  constant_relation_with_relation = new gc.Relation([name_term,new gc.ConstantTerm("1"),new gc.RelationTerm(constant_relation_with_1_term)])


  describe '#is_named', () ->
    it 'should correctly detect if a relation is named', () ->
      named_relation.is_named().should.equal true
    it 'should detect if a relation is named and if it is named the specified value', () ->
      named_relation.is_named("Named").should.equal true
      named_relation.is_named("XXX").should.equal false

  describe '#get_name', () ->
    it 'should return the name of a named relation', () ->
       named_relation.get_name().should.equal "Named"   
    it 'should throw an execption if the name of a non named relation is expected', () ->
       expect(->anon_relation.get_name()).to.throw  "Cannot retreive the name of a non named relation."

  describe '#has_signature', () ->
    it 'should return true of the term types match the provided list of term types', () ->
      named_relation.has_signature([gc.ConstantTerm,gc.VariableTerm]).should.equal true

    it 'should return false if the number of terms are not the same as the list of types', () ->
      named_relation.has_signature([gc.ConstantTerm]).should.equal false
      named_relation.has_signature([]).should.equal false
      named_relation.has_signature([gc.ConstantTerm,gc.ConstantTerm,gc.ConstantTerm]).should.equal false

    it 'should return false if the types provided do not match the types of the terms', () ->
      named_relation.has_signature([gc.VariableTerm,gc.VariableTerm]).should.equal false

  describe '#set_rule', () ->
    rule = new gc.Rule(new gc.ConstantTerm('head'),[new gc.ConstantTerm('body_1')])
    it 'should set the rule property of a relation to the rule specified.', () ->
      expect(named_relation.rule).to.be.null
      named_relation.set_rule rule
      named_relation.rule.should.not.equal null

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
    it 'should calculate the hash lazily', () ->
      constant_relation_with_relation.set_hash("xxx")
      constant_relation_with_relation.get_hash().should.equal "xxx"

      












  