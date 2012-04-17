log = require 'loggo'

module.exports = (shakeConfig) ->
  log.info "Available tasks:"
  log.info "--", key for key, val of shakeConfig when typeof val is 'function'