status = require '../'
should = require 'should'
require 'mocha'

describe 'loading', ->
  it 'should load a valid plugin', (done) ->
    plugin =
      name: "test"
      author: "Contra"
      version: "0.0.1"

    res = status.loadPlugin plugin
    res.should.equal true
    status.removePlugin plugin.name
    done()

  it 'should not load with an invalid name', (done) ->
    plugin =
      name: "test lol !!"
      author: "Contra"
      version: "0.0.1"

    res = status.loadPlugin plugin
    res.should.not.equal true
    status.removePlugin plugin.name
    done()

  it 'should not load with an invalid version', (done) ->
    plugin =
      name: "test"
      author: "Contra"
      version: "-1"

    res = status.loadPlugin plugin
    res.should.not.equal true
    status.removePlugin plugin.name
    done()
    
describe 'listing', ->
  it 'should load and list a valid plugin', (done) ->
    plugin =
      name: "test"
      author: "Contra"
      version: "0.0.1"

    res = status.loadPlugin plugin
    res.should.equal true
    status.getPlugins()[plugin.name].meta.version.should.equal plugin.version
    status.removePlugin plugin.name
    done()

describe 'executing', ->
  it 'should load and execute a valid plugin', (done) ->
    plugin =
      name: "test"
      author: "Contra"
      version: "0.0.1"
      doStuff: (done, a, b) -> done a+b

    res = status.loadPlugin plugin
    res.should.equal true
    plug = status.getPlugins()[plugin.name]
    plug.run "doStuff", [1,2], (err, ret) ->
      should.not.exist err
      should.exist ret
      ret.should.equal 3
      status.removePlugin plugin.name
      done()