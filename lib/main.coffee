async = require 'async'
util = require 'util'
{spawn} = require 'child_process'

exec = (cmd, opt, cb) ->
  child = spawn cmd, opt
  res = null
  child.stderr.on "data", (chunk) -> (res?=[]).push {type: 'stderr', message: String(chunk).trim()}
  child.stdout.on "data", (chunk) -> (res?=[]).push {type: 'stdout', message: String(chunk).trim()}
  util.pump child.stdout, process.stdout
  util.pump child.stderr, process.stderr
  
  child.on "exit", (code) -> cb? res, code

module.exports =
  # SSH stuff
  getRemote: (host, username, cb) ->
    remote = {}
    host = "#{username}@#{host}" if username?
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