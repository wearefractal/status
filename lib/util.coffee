os = require 'os'
fs = require 'fs'
{resolve, existsSync} = require 'path'

util =
  getPlatform: -> (if os.type().match(/^Win/) then 'win' else 'unix')
  splitPath: (p) -> (if util.getPlatform() is "win" then p.split ";" else p.split ":")

  which: (cmd) ->
    return null unless cmd?
    pathEnv = process.env.path or process.env.Path or process.env.PATH
    pathArray = util.splitPath pathEnv
    where = null
    if cmd.search(/\//) is -1
      pathArray.forEach (dir) ->
        return if where
        attempt = resolve dir + "/" + cmd
        return where = attempt if existsSync attempt
        if util.getPlatform() is "win"
          baseAttempt = attempt
          attempt = baseAttempt + ".exe"
          return where = attempt if existsSync attempt
          attempt = baseAttempt + ".cmd"
          return where = attempt if existsSync attempt
          attempt = baseAttempt + ".bat"
          return where = attempt if existsSync attempt

    return null if !existsSync(cmd) and !where

    return where or resolve cmd

  calculateCPU: ({user, sys, idle}, pretty=false) ->
    out =
      total: user+sys+idle
      free: idle
      used:
        total: user+sys
        user: user
        system: sys
        
    # TODO: this is all incorrect
    if pretty
      out.free = "#{Math.floor out.free/out.total}%"
      out.used.total = "#{Math.floor out.total/out.used.total}%"
      out.used.user = "#{Math.floor out.total/out.used.user}%"
      out.used.system = "#{Math.floor out.total/out.used.system}%"
    return out

  convertSeconds: (secs) ->
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

  prettySeconds: (secs) ->
    time = util.convertSeconds secs
    out = ""
    out += "#{time.days} days " if time.days
    out += "#{time.hours} hours " if time.hours
    out += "#{time.minutes} minutes" if time.minutes
    out += " #{time.seconds} seconds" if time.seconds
    return out

  readableSize: (size) ->
    units = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
    i = 0
    while size >= 1024
      size /= 1024
      ++i
    return "#{size.toFixed(2)} #{units[i]}"

  readableSpeed: (size) ->
    units = ["MHz", "GHz", "THz", "PHz", "EHz", "ZHz", "YHz"]
    i = 0
    while size >= 1000
      size /= 1000
      ++i
    return "#{size.toFixed(2)} #{units[i]}"

module.exports = util