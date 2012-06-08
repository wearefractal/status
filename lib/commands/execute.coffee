async = require "async"
log = require "loggo"
status = require "../main"

parseOps = (ops) ->
  # TODO: better way to do this - putting ]: in args will break it
  temp = []
  buff = ""
  safe = false
  for ch,i in ops
    if ch is ':' and not safe
      temp.push buff
      buff = ""
      continue
    else if ch is '['
      safe = true
    else if ch is ']' and ops[i+1] is ':' or not ops[i+1]
      safe = false
    buff+=ch
  temp.push buff

  operations = []
  for op in temp
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
  return operations

module.exports = (ops, {name, plain}) ->
  process.env.PLAIN_TEXT = true if plain
  plugin = status.list()[name]
  return log.error "Plugin '#{name}' is not installed" unless plugin
  return log.error "No operations specified" unless typeof ops is "string" and ops.length > 0
  operations = parseOps ops
  return log.error "No operations specified" unless operations.length > 0

  out = {}
  runOperation = (op, cb) ->
    plugin.run op.name, op.args, (err, ret) ->
      return cb "#{op.name}: #{err.message or err}" if err?
      if process.env.PLAIN_TEXT
        out = ret
      else
        out[op.name] = ret
      return cb()

  async.forEach operations, runOperation, (err) ->
    return log.error err if err?
    if process.env.PLAIN_TEXT
      console.log out
    else
      console.log JSON.stringify out
    process.exit()