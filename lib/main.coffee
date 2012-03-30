async = require 'async'
{spawn} = require 'child_process'

exec = (cmd, opt, cb) ->
  child = spawn cmd, opt
  err = null
  res = null
  child.stderr.on "data", (chunk) -> (err?=[]).push String(chunk).trim()
  child.stdout.on "data", (chunk) -> (res?=[]).push String(chunk).trim()

  child.on "exit", ->
    err = err.join '\n' if err?
    res = res.join '\n' if res?
    cb? err, res

module.exports =
  # SSH stuff
  target: null

  getRemote: (host, cb) ->
    remote = {}
    remote.exec = (cmd, cb) -> exec 'ssh', [host, cmd], cb
    remote.run = (cmds..., cb) -> async.mapSeries cmds, remote.exec, cb
    return remote

  # Local stuff
  getLocal: (cwd) ->
    opt = cwd: cwd
    local = {}
    local.exec = (cmd, cb) -> exec 'sh', ['-c', cmd], cb
    local.run = (cmds..., cb) -> async.mapSeries cmds, local.exec, cb
    return local