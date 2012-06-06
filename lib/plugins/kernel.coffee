{exec} = require "child_process"

module.exports =
  meta:
    name: "kernel"
    author: "Contra"
    version: "0.0.1"

  version: (done) ->
    exec "uname -r", (err, stdout, stderr) ->
      throw err if err?
      done stdout.trim()