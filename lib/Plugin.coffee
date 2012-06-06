{EventEmitter} = require 'events'

class Plugin extends EventEmitter
  meta: {}
  operations: {}

  constructor: (plug) ->
    # Clone data from input to this
    @meta =
      name: plug.name
      author: plug.author
      version: plug.version
    @operations[k]=v for own k,v of plug when typeof v is "function"

  run: (name, args, done) ->
    op = @operations[name]
    return done "Invalid operation name" unless typeof name is "string" and name.length > 0
    return done "Operation #{name} does not exist in #{@meta.name}" unless op?
    return done "Invalid arguments" unless Array.isArray args
    cb = (ret) -> done null, ret
    op cb, args...
    return

module.exports = Plugin