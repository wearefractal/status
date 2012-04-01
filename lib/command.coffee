program = require 'commander'
log = require 'loggo'
async = require 'async'
shake = require '../index'
{join} = require 'path'

log.setName 'shake'
package = require join __dirname, '../package.json'

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
      .version(package.version)
      .usage('<tasks>')
      .option '-t, --tasks', 'list tasks'

    program.command('*')
      .description('Execute tasks')
      .action (tasks, mode) ->
        tasks = tasks.split ':'
        log.info "Target: #{shakeConfig.target}"
        remote = shake.getRemote shakeConfig.target, shakeConfig.username
        local = shake.getLocal process.cwd()

        runTask = (task, cb) ->
          log.info "Executing '#{task}'..."
          taskFn = shakeConfig[task]
          return log.error "'#{task}' does not exist" if typeof taskFn isnt 'function'
          taskFn local, remote, (res) ->
            if res?
              for val in res
                unless res? and res.type?
                  log.info res
                else
                  log.error err if res.type is 'stderr'
                  log.info if res.type is 'stdout'
            cb null, res

        async.mapSeries tasks, runTask, -> log.info "Tasks completed!"

    program.parse argv

    if program.tasks
      log.info "Available tasks:"
      log.info "--", key for key, val of shakeConfig when typeof val is 'function'