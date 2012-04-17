shake = require '../../index'
async = require 'async'
log = require 'loggo'

module.exports = (shakeConfig) ->
  (input, app) ->
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
      taskFn = shakeConfig[task.name]
      return log.error "'#{task.name}' does not exist" if typeof taskFn isnt 'function'
      handleFn = (res) ->
        log.info res if res?
        cb null, res
      taskFn local, remote, handleFn, task.args...

    async.mapSeries tasks, runTask, -> log.info "Tasks completed!"