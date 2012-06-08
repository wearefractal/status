status = require "../main"

parseArgs = (fn) ->
  str = fn.toString()
  return str[str.indexOf('(')+1...str.indexOf(')')].match /([^\s,]+)/g

module.exports = ({json}) ->
  plugins = []
  for name, plug of status.list()
    out =
      name: plug.meta.name
      author: plug.meta.author
      version: plug.meta.version
      description: plug.meta.description
      operations: []
    out.operations.push {name:name,arguments:parseArgs(fn)[1..]} for name,fn of plug.operations
    plugins.push out

  if json
    console.log JSON.stringify plugins
  else
    for plug in plugins
      name = "#{plug.name}@#{plug.version}"
      name += " - #{plug.description}" if typeof plug.description is "string"
      console.log name
      console.log "  * #{op.name}" for op in plug.operations
  return