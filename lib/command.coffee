log = require "loggo"
log.setName "status"

list = require "./commands/list"
execute = require "./commands/execute"

module.exports =
  run: (argv, program) ->
    program.version require("../package.json").version
    program.usage "<plugin> <operations>"
    program.option "-p, --plugins", "list installed plugins"
    program.command("*").action execute
    program.on '--help', ->
      console.log '  Examples:\r\n'
      console.log '    $ uptime total'
      console.log '    $ processes grep("skype"):all\r\n'

    program.parse argv

    list() if program.plugins
    return