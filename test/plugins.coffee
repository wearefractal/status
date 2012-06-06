status = require '../'
should = require 'should'
require 'mocha'

describe 'loading', ->
  it 'should load a valid plugin', (done) ->
    plugin =
      meta:
        name: "test"
        author: "Contra"
        version: "0.0.1"

    res = status.load plugin
    res.should.equal true
    status.remove plugin.meta.name
    done()

  it 'should not load with an invalid name', (done) ->
    plugin =
      meta:
        name: "test lol !!"
        author: "Contra"
        version: "0.0.1"

    res = status.load plugin
    res.should.not.equal true
    status.remove plugin.meta.name
    done()

  it 'should not load with an invalid version', (done) ->
    plugin =
      meta:
        name: "test"
        author: "Contra"
        version: "-1"

    res = status.load plugin
    res.should.not.equal true
    status.remove plugin.meta.name
    done()
    
describe 'listing', ->
  it 'should load and list a valid plugin', (done) ->
    plugin =
      meta:
        name: "test"
        author: "Contra"
        version: "0.0.1"

    res = status.load plugin
    res.should.equal true
    status.list()[plugin.meta.name].meta.version.should.equal plugin.meta.version
    status.remove plugin.meta.name
    done()

describe 'executing', ->
  it 'should load and execute a valid plugin', (done) ->
    plugin =
      meta:
        name: "test"
        author: "Contra"
        version: "0.0.1"
      doStuff: (done, a, b) -> done a+b

    res = status.load plugin
    res.should.equal true
    plug = status.list()[plugin.meta.name]
    plug.run "doStuff", [1,2], (err, ret) ->
      should.not.exist err
      should.exist ret
      ret.should.equal 3
      status.remove plugin.meta.name
      done()