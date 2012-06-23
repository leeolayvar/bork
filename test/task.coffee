#
# test/task.coffee
#
# Copyright (c) 2012 Lee Olayvar <leeolayvar@gmail.com>
# MIT Licensed
#
should = require 'should'


# There are here so my IDE will shut the hell up.
before = global.before
before_each = global.beforeEach
describe = global.describe
it = global.it


describe 'Task', ->
  {Task} = require '../lib/task'
  
  describe '#constructor', ->
    describe 'with no args', ->
      task = undefined
      before ->
        task = new Task()
      
      it 'should create a function of it\'s own', ->
        task._fn.should.be.an.instanceof Function
    
    describe 'with a function arg', ->
      task = undefined
      fn = undefined
      before ->
        fn = ->
        task = new Task fn
      
      it 'should store the given function', ->
        task._fn.should.equal fn
    
    describe 'with a task as an arg', ->
      task = undefined
      arg_task = undefined
      before ->
        arg_task = new Task()
        task = new Task arg_task
      
      it 'should store the arg_task as a seq', ->
        task._seqs.should.eql [arg_task]
  
  describe '#is_req', ->
  
  describe '#link', ->
    describe 'with a root task', ->
      root = null
      before_each ->
        root = new Task()
      describe 'and a link task that doesn\'t complete.', ->
        link = next = null
        before_each ->
          link = new Task (next_arg) -> next = next_arg
          root.link link
        describe 'Start the root', ->
          before_each ->
            root.start()
          
          it 'and it should show started and completed, but not started seqs', ->
            root.started().should.be.true
            root.completed().should.be.true
            root.started_seqs().should.be.false
          
          it 'and link should show started, not completed, and not started seqs', ->
            link.started().should.be.true
            link.completed().should.be.false
            link.started_seqs().should.be.false
          
          describe 'now complete the link task', ->
            before_each ->
              next()
            
            it 'root should show started_seqs', ->
              root.started_seqs().should.be.true
            
            it 'root should show completed and started_seqs', ->
              link.completed().should.be.true
              link.started_seqs().should.be.true
  
  describe '#par', ->
    describe 'root.par to a task that does not complete', ->
      root = par = null
      before_each ->
        root = new Task()
        par = new Task (next) ->
        root.par par
      
      it 'should store the par-task in @_pars', ->
        root._pars.should.eql [par]
      
      it 'should also store root-task in par-task._pars', ->
        par._pars.should.eql [root]
      
      describe 'and then start root', ->
        before_each ->
          root.start()
        
        it 'root should show started', ->
          root.started().should.be.true
        
        it 'par should show started', ->
          root.started().should.be.true
      
      describe 'and then start par', ->
        before_each ->
          par.start()
        
        it 'root should show started', ->
          root.started().should.be.true
        
        it 'par should show started', ->
          root.started().should.be.true
  
  describe '#req', ->
  
  describe '#seq', ->
