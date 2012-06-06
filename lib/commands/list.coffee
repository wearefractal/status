log = require "loggo"
{list} = require "../main"

module.exports = ->
  for name, plug of list()
    name = " #{name}@#{plug.meta.version}"
    name += " - #{plug.meta.description}" if typeof plug.meta.description is "string"
    log.info name
    log.info "   * #{name}" for name,val of plug.operations
  return