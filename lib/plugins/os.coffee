os = require "os"
{exec} = require "child_process"
{readableSpeed, convertSeconds, prettySeconds} = util = require "../util"

module.exports =
  meta:
    name: "os"
    author: "Contra"
    version: "0.0.1"
    description: "System information"
  
  load: (done) -> done (Math.floor(num*1000)/1000 for num in os.loadavg())

  uptime: (done, format="raw") ->
    secs = os.uptime()
    if format is "raw"
      done convertSeconds secs
    else if format is "pretty"
      done prettySeconds secs
    else if format is "full"
      done secs
    else
      throw "Invalid format specified"

  arch: (done) -> done os.arch()
  platform: (done) -> done os.platform()
  type: (done) -> done os.type()
  hostname: (done) -> done os.hostname()
  kernel: (done) -> done os.release()
  environment: (done) -> done process.env
  
  drives: (done) ->
    throw "df not installed" unless util.which "df"
    throw "awk not installed" unless util.which "awk"
    exec "df | awk '{print $1}'", (err, stdout) ->
      throw err if err?
      out = {}
      [head, names..., tail] = stdout.split '\n'
      done names

  cpus: (done, format="raw") ->
    if format is "raw"
      done ({model:cpu.model,speed:cpu.speed} for cpu in os.cpus())
    else if format is "pretty"
      done ({model:cpu.model,speed:readableSpeed(cpu.speed)} for cpu in os.cpus())
    else
      throw "Invalid format specified"

  network: (done) -> done os.networkInterfaces()