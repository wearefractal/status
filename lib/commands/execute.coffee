async = require "async"
log = require "loggo"
status = require "../main"

module.exports = (pluginName, ops, app) ->
  plugin = status.list()[pluginName]
  return log.error "Plugin '#{pluginName}' is not installed" unless plugin
  return log.error "No operations specified" unless typeof ops is "string" and ops.length > 0

  operations = []
  for op in ops.split ':'
    if '[' in op and ']' in op
      name = op[0...op.indexOf('[')]
      try
        args = eval op[op.indexOf('[')..op.lastIndexOf(']')]
      catch err
        return log.error "Invalid arguments: #{err.message}"
    else
      name = op
      args = []
    operations.push name: name, args: args
  return log.error "No operations specified" unless operations.length > 0

  out = {}
  runOperation = (op, cb) ->
    try
      plugin.run op.name, op.args, (err, ret) ->
        return cb "#{op.name}: #{err.message or err}" if err?
        out[op.name] = ret
        return cb()
    catch err
      return cb "#{op.name}: #{err.message or err}"

  async.forEach operations, runOperation, (err) ->
    return log.error err if err?
    console.log JSON.stringify out
    process.exit()