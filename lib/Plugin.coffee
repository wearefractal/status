{EventEmitter} = require 'events'

class Plugin
  constructor: (plug) ->
    @meta = plug.meta
    @catch =
      _default: plug._default
    @operations = {}
    @operations[k] = v for k,v of plug when typeof v is "function" and k isnt "meta"
    return

  run: (name, args, done) ->
    op = @operations[name] or @catch._default
    return done "#{name}: Invalid operation name" unless typeof name is "string" and name.length > 0
    return done "#{name}: Operation #{name} does not exist in #{@meta.name}" unless op?
    return done "#{name}: Invalid arguments" unless Array.isArray args
    try
      cb = (ret) -> done null, ret
      op cb, args...
    catch err
      return done "#{name}: #{err.message or err}"

module.exports = Plugin