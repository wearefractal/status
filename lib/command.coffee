program = require 'commander'
log = require 'loggo'
async = require 'async'
shake = require '../index'
{existsSync, join} = require 'path'

log.setName 'shake'
package = require join __dirname, '../package.json'

module.exports =
  run: (argv) ->
    program
      .version(package.version)
      .usage '<tasks>'

    program.command('* <mode>')
      .description('Execute tasks')
      .action (tasks, mode) ->
        tasks = tasks.split ':'
        # TODO: fix shake.mode
        shake.mode = mode

        # Find shake file
        shakeFile = require.resolve join process.cwd(), '.shake' unless existsSync shakeFile
        return log.error ".shake not found!" unless existsSync shakeFile
        shakeConfig = require shakeFile

        remote = shake.getRemote shake.target
        local = shake.getLocal process.cwd()

        runTask = (task, cb) ->
          log.info "Executing '#{task}'..."
          taskFn = shakeConfig[task]
          return log.error "'#{task}' does not exist" if typeof taskFn isnt 'function'
          taskFn local, remote, (err, res) ->
            log.error err if err?
            log.info res if res?
            cb err, res

        async.mapSeries tasks, runTask, (err, res) -> log.info "Tasks completed!"

    program.parse argv