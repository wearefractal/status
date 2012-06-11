os = require "os"
{exec} = require "child_process"
{readableSpeed, seconds, which} = require "fractal"

module.exports =
  meta:
    name: "os"
    author: "Contra"
    version: "0.0.1"
    description: "System information"
  
  load: (done) -> 
    calc = (Math.floor(num*1000)/1000 for num in os.loadavg())
    calc = Math.floor((calc.reduce((t,s)->t+s)/calc.length)*100)/100 if process.env.PLAIN_TEXT
    done calc

  uptime: (done, format="raw") ->
    secs = os.uptime()
    time = seconds.convert secs
    if format is "raw"
      time = seconds.small time if process.env.PLAIN_TEXT
      done time
    else if format is "pretty"
      done seconds.pretty time
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
    throw "df not installed" unless which "df"
    throw "awk not installed" unless which "awk"
    exec "df | awk '{print $1}'", (err, stdout) ->
      throw err if err?
      out = {}
      [head, names..., tail] = stdout.split '\n'
      done names

  cpus: (done, format="raw") ->
    calc = (cpu.model for cpu in os.cpus())
    done (if process.env.PLAIN_TEXT then calc[0] else calc)

  network: (done) -> done os.networkInterfaces()