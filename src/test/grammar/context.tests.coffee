fs = require('fs')

_ = require("underscore")

should = require('chai').should()
expect = require('chai').expect

terms = require('../../grammar/terms')
Relation = require('../../grammar/relation').Relation
Context = require('../../grammar/context').Context
parser = require('../../grammar/parser')

it_should = (description,text,cb) ->
  it "should #{description} - text", () ->
    context = parser.parse(text);
    cb(context)

describe 'Context', () ->

  name_term = new terms.ConstantTerm('name')
  constant_term = new terms.ConstantTerm('constant')
  variable_term = new terms.VariableTerm('variable')

  describe '#create_relation', () ->

    it_should 'create a new relation term','(name ?variable constant)', (context) ->
      context.relations.length.should.equal 1
      _.keys(context.relation_hash_lookup).length.should.equal 1

    it_should 'return a ref to the existing relation if it exists in the context' ,'(name ?x)(name ?x)' , (context) ->
      context.relations.length.should.equal 1
      _.keys(context.relation_hash_lookup).length.should.equal 1

    it_should 'add the constant relations into the constant pool', '(index 1)(index 2)', (context) ->
      context.relations.length.should.equal 2
      context.constant_relations.length.should.equal 2

    it_should 'add the variable relations into the variable pool', '(index ?x)(index ?y)', (context) ->
      context.relations.length.should.equal 2
      context.variable_relations.length.should.equal 2

    it_should 'link variable relations to constant relations', '(index 1)(index ?x)(index 2)', (context) ->
      context.relations.length.should.equal 3
      context.constant_relations.length.should.equal 2
      context.variable_relations.length.should.equal 1
      _.keys(context.productions).length.should.equal 1
      context.productions[1].length.should.equal 2
      context.productions[1][0].should.equal 0
      context.productions[1][1].should.equal 2


  describe '#lookup_relation_by_hash', () ->
    
    it 'should return the relation with the given hash in the context', () ->
      context = new Context()
      relation = context.create_relation([name_term,variable_term,constant_term])
      lookup_relation = context.lookup_relation_by_hash(relation.get_hash())
      lookup_relation.terms[0].name.should.equal relation.terms[0].name
      lookup_relation.terms[1].name.should.equal relation.terms[1].name
      lookup_relation.terms[2].name.should.equal relation.terms[2].name


  describe '#evaluate', () ->
        
    it_should 'should evaluate the relation to true', '(index 1)' ,(context) ->
      context.evaluate(0).should.equal true
    it_should 'should evaluate the relation to true', '(index 1)( <= (move ?x) (index ?x) )' ,(context) ->
      #console.log context.dependants
      #console.log context.productions
      context.evaluate(0).should.equal true










