{EventEmitter} = require 'events'

class Plugin extends EventEmitter
  constructor: (plug) ->
    @meta = plug.meta
    @catch = {}
    @operations = {}
    for own k,v of plug when typeof v is "function" and k isnt "meta"
      if k is "_default"
        @catch[k] = v
      else
        @operations[k] = v
    return

  run: (name, args, done) ->
    op = @operations[name] or @catch._default
    return done "Invalid operation name" unless typeof name is "string" and name.length > 0
    return done "Operation #{name} does not exist in #{@meta.name}" unless op?
    return done "Invalid arguments" unless Array.isArray args

    cb = (ret) -> done null, ret
    op cb, args...

module.exports = Plugin