{EventEmitter} = require 'events'

class Plugin extends EventEmitter
  constructor: (plug) ->
    @meta = plug.meta
    @operations = {}
    @operations[k] = v for k,v of plug when typeof v is "function" and k isnt "meta"
    @emit 'loaded'
    return

  get: (name) -> @operations[name] or @operations._default? name

  run: (name, args, done) ->
    op = @get name
    return done "#{name}: Operation #{name} does not exist in #{@meta.name}" unless op?
    return done "#{name}: Invalid arguments" unless Array.isArray args
    try
      cb = (ret) -> done null, ret
      @emit 'task', name, args
      op cb, args...
    catch err
      return done "#{name}: #{err.message or err}"

module.exports = Plugin