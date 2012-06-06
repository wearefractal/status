os = require 'os'

convertSeconds = (secs) ->
  days = Math.floor secs / 86400
  hours = Math.floor (secs % 86400) / 3600
  minutes = Math.floor ((secs % 86400) % 3600) / 60
  seconds = Math.floor ((secs % 86400) % 3600) % 60

  out = {}
  out.days = days unless days is 0
  out.hours = hours unless hours is 0
  out.minutes = minutes unless minutes is 0
  out.seconds = seconds unless seconds is 0
  return out

prettySeconds = (secs) ->
  time = convertSeconds secs
  out = ""
  out += "#{time.days} days " if time.days
  out += "#{time.hours} hours " if time.hours
  out += "#{time.minutes} minutes" if time.minutes
  out += " #{time.seconds} seconds" if time.seconds
  return out

module.exports =
  meta:
    name: "uptime"
    author: "Contra"
    version: "0.0.1"

  load: (done) -> done (Math.floor(num*1000)/1000 for num in os.loadavg())

  total: (done, format="full") ->
    secs = os.uptime()
    if format is "raw"
      done secs
    else if format is "full"
      done convertSeconds secs
    else if format is "pretty"
      done prettySeconds secs
    else
      throw "Invalid format specified"
