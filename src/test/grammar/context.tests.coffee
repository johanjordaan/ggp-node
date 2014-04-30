fs = require('fs')

_ = require("underscore")

should = require('chai').should()
expect = require('chai').expect

terms = require('../../grammar/terms')
Relation = require('../../grammar/relation').Relation
Context = require('../../grammar/context').Context


describe 'Context', () ->

  name_term = new terms.ConstantTerm('name')
  constant_term = new terms.ConstantTerm('constant')
  variable_term = new terms.ConstantTerm('variable')

  describe '#create_relation', () ->

    it 'should create a new relation term', () ->
      context = new Context()
      relation = context.create_relation([name_term,variable_term,constant_term])
      context.relations.length.should.equal 1
      _.keys(context.relation_hash_lookup).length.should.equal 1
      context.relation_hash_lookup[relation.get_hash()].should.equal 0 

    it 'should return a ref to the existing relation if it exists in the context', () ->
      context = new Context()
      relation1 = context.create_relation([name_term,variable_term,constant_term])
      relation2 = context.create_relation([name_term,variable_term,constant_term])
      context.relations.length.should.equal 1
      _.keys(context.relation_hash_lookup).length.should.equal 1
      context.relation_hash_lookup[relation1.get_hash()].should.equal 0 

  describe '#lookup_relation_by_hash', () ->
    it 'should return the relation with the given hash in the context', () ->
      context = new Context()
      relation = context.create_relation([name_term,variable_term,constant_term])
      lookup_relation = context.lookup_relation_by_hash(relation.get_hash())
      lookup_relation.terms[0].name.should.equal relation.terms[0].name
      lookup_relation.terms[1].name.should.equal relation.terms[1].name
      lookup_relation.terms[2].name.should.equal relation.terms[2].name


      



