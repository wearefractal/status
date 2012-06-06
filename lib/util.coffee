util =
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