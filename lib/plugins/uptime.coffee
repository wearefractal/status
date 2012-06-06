status = require '../main'
{exec} = require "child_process"

# Sample data: " 05:38:24 up  1:44,  0 users,  load average: 1.05, 1.06, 0.96"
runCommand = (cb) ->
  exec "uptime", (err, stdout, stderr) ->
    throw err if err?
    [uptime, time, users, load] = stdout.trim().replace(/,/g, '').split '  '
    [uptime] = uptime.split ' '
    [hours, minutes, seconds] = uptime.split ':'
    [users] = users.split ' '
    [_, _, avg1, avg2, avg3] = load.split ' '
    cb
      uptime:
        hours: parseInt hours
        minutes: parseInt minutes
        seconds: parseInt seconds
      time: time
      users: parseInt users
      load: [parseFloat(avg1), parseFloat(avg2), parseFloat(avg3)]

module.exports =
  meta:
    name: "uptime"
    author: "Contra"
    version: "0.0.1"

  load: (done) ->
    runCommand (res) -> done res.load

  users: (done) ->
    runCommand (res) -> done res.users

  total: (done, format="full") ->
    runCommand (res) ->
      if format is "full"
        done res.uptime
      else if format is "pretty"
        done "#{res.uptime.hours} hours, #{res.uptime.minutes} minutes, #{res.uptime.seconds} seconds"
      else if format is "prettyshort"
        done "#{res.uptime.hours} hrs, #{res.uptime.minutes} mins, #{res.uptime.seconds} secs"
      else
        throw "Invalid format specified"
