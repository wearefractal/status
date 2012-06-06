log = require "loggo"
{getPlugins} = require "../main"

module.exports = ->
  log.info "Installed plugins:"
  log.info " - #{name} #{plug.meta.version} by #{plug.meta.author}" for name,plug of getPlugins()
  return