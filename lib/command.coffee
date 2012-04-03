program = require 'commander'
log = require 'loggo'
async = require 'async'
shake = require '../index'
{join} = require 'path'

log.setName 'shake'
pack = require join __dirname, '../package.json'

getShakeFile = ->
  # Find shake file
  try
    shakeFile = require.resolve join process.cwd(), '.shake'
  catch e
    return log.error ".shake not found!"
  shakeConfig = require shakeFile
  return log.error "Missing target in .shake" if typeof shakeConfig.target isnt 'string'
  return shakeConfig

shakeConfig = getShakeFile()

module.exports =
  run: (argv) ->
    return unless shakeConfig
    program
      .version(pack.version)
      .usage('<tasks>')
      .option '-t, --tasks', 'list tasks'

    program.command('*')
      .description('Execute tasks')
      .action (input, mode) ->
        tasks = []
        for task in input.split ':'
          if '[' in task and ']' in task
            name = task[0...task.indexOf('[')]
            args = eval task[task.indexOf('[')..task.lastIndexOf(']')]
          else
            name = task
            args = []
          tasks.push name: name, args: args
        log.info "Target: #{shakeConfig.target}"
        remote = shake.getRemote shakeConfig.target, shakeConfig.username
        local = shake.getLocal process.cwd()

        runTask = (task, cb) ->
          log.info "Executing '#{task.name}'..."
          taskFn = shakeConfig[task]
          return log.error "'#{task.name}' does not exist" if typeof taskFn isnt 'function'
          handleFn = (res) ->
            res = if Array.isArray res then res else [res]
            for val in res when val?
              log.info val unless val.type?
              log.error val.message if val.type is 'stderr'
              log.info val.message if val.type is 'stdout'
            cb null, res
          taskFn local, remote, handleFn, args...

        async.mapSeries tasks, runTask, -> log.info "Tasks completed!"

    program.parse argv

    if program.tasks
      log.info "Available tasks:"
      log.info "--", key for key, val of shakeConfig when typeof val is 'function'
