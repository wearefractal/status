os = require "os"
{exec} = require "child_process"
{readableSpeed, convertSeconds, prettySeconds} = util = require "../util"

module.exports =
  meta:
    name: "os"
    author: "Contra"
    version: "0.0.1"
    description: "System information"
  
  load: (done) -> 
    calc = (Math.floor(num*1000)/1000 for num in os.loadavg())
    avg = Math.floor((calc.reduce((t,s)->t+s)/calc.length)*100)/100
    done (if process.env.PLAIN_TEXT then avg else calc)

  uptime: (done, format="raw") ->
    secs = os.uptime()
    if format is "raw"
      time = convertSeconds secs
      if process.env.PLAIN_TEXT
        time.days ?= "00"
        time.hours ?= "00"
        time.minutes ?= "00"
        time.seconds ?= "00"
        time = "#{time.days}:#{time.hours}:#{time.minutes}:#{time.seconds}"
      done time
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
    calc = (cpu.model for cpu in os.cpus())
    done (if process.env.PLAIN_TEXT then calc[0] else calc)

  network: (done) -> done os.networkInterfaces()