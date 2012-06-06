log = require "loggo"
log.setName "status"

status = require "./main"
list = require "./commands/list"
execute = require "./commands/execute"

module.exports =
  run: (argv, program) ->
    status.loadDefaults()
    program.version require("../package.json").version
    program.usage "<plugin> <tasks>"
    program.option "-p, --plugins", "list installed plugins"
    program.command("*").action execute
    program.parse argv

    list() if program.plugins
    return