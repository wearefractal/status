async = require "async"
log = require "loggo"
status = require "../main"

module.exports = (pluginName, ops, app) ->
  plugin = status.list()[pluginName]
  return log.error "Plugin '#{pluginName}' is not installed" unless plugin
  return log.error "No operations specified" unless typeof ops is "string" and ops.length > 0

  operations = []
  for op in ops.split ':'
    if '(' in op and ')' in op
      name = op[0...op.indexOf('(')]
      args = eval "[" + op[op.indexOf('(')..op.lastIndexOf(')')] + "]"
    else
      name = op
      args = []
    operations.push name: name, args: args
  return log.error "No operations specified" unless operations.length > 0

  out = {}
  runOperation = (op, cb) ->
    try
      plugin.run op.name, op.args, (err, ret) ->
        return cb err if err?
        out[op.name] = ret
        return cb()
    catch err
      return cb err

  async.forEach operations, runOperation, (err) ->
    return log.error err.message if err?
    console.log JSON.stringify out