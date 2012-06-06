{exec} = require "child_process"
util = require '../util'

throw "ps not installed" unless util.which "ps"

runPs = (args, cb) ->
  exec "ps #{args}", (err, stdout, stderr) ->
    throw err if err?
    [head, processes..., tail] = stdout.split '\n'
    out = []
    for process in processes
      process = (part for part in process.split(' ') when part.length > 0) # clean
      [user, pid, cpu, mem, vsz, rss, tty, stat, start, time, command...] = process
      out.push 
        user: user
        pid: parseInt pid
        cpu: parseFloat cpu
        mem: parseFloat mem
        vsz: parseInt vsz
        rss: parseInt rss
        tty: (if tty is '?' then null else tty)
        stat: stat
        start: start
        time: time
        command: command.join ' '
    cb out

module.exports =
  meta:
    name: "processes"
    author: "Contra"
    version: "0.0.1"
    description: "Process information"

  all: (done) -> runPs "aux", done
  mine: (done) -> runPs "ux", done
  grep: (done, text) -> runPs "aux | grep #{text}", done