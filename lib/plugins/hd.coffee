{exec} = require "child_process"
{readableSize} = util = require '../util'

runCommand = (pretty=false, cb) ->
  throw "df not installed" unless util.which "df"
  throw "awk not installed" unless util.which "awk"
  exec "df --block-size=1 | awk '{print $1,$3,$4}'", (err, stdout) ->
    throw err if err?
    out = {}
    [head, drives..., tail] = stdout.split '\n'
    for drive in drives
      [name, used, free, usedPercent] = drive.split ' '
      out[name] =
        used: parseInt used
        free: parseInt free
        total: parseInt(free)+parseInt(used)
      out[name][k]=readableSize(v) for k,v of out[name] if pretty
    cb out

module.exports =
  meta:
    name: "hd"
    author: "Contra"
    version: "0.0.1"
    description: "Hard Disk information"

  temp: (done, unit="C") ->
    throw "hddtemp not installed" unless util.which "hddtemp"
    exec "hddtemp /dev/sda -n --unit=#{unit}", (err, stdout) ->
      throw err if err?
      done parseInt stdout

  usage: (done, format="raw") ->
    runCommand (format is "pretty"), done