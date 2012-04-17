program = require 'commander'
log = require 'loggo'
execute = require './commands/execute'
list = require './commands/execute'
{join} = require 'path'

log.setName 'shake'

getShakeFile = ->
  try
    shakeFile = require.resolve join process.cwd(), '.shake'
  catch e
    return log.error ".shake not found!"
  shakeConfig = require shakeFile
  return log.error "Invalid .shake file" unless shakeConfig?
  return log.error "Missing target in .shake" if typeof shakeConfig.target isnt 'string'
  return shakeConfig

shakeConfig = getShakeFile()

module.exports =
  run: (argv) ->
    return unless shakeConfig?
    program.usage '<tasks>'
    program.option '-t, --tasks', 'list tasks'
    program.command('*').action execute shakeConfig
    program.parse argv
    list shakeConfig if program.tasks
