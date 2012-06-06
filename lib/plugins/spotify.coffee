{exec} = require "child_process"
dbus = require "dbus"

getMeta = (cb) ->
  exec "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'", (err, stdout, stderr) ->
    throw err if err?
    out = {}
    for def in stdout.match /entry\(([\S\s]*?)\)/ig
      [head, key, val..., tail] = def.split '\n'
      key = key.match(/"([\S\s]*?)"/i)[1].split(':')[1]
      [_, val...] = val.join('').trim().split('  ').join('').trim().split(' ')
      val = val.join ''
      match = val.match /"(.*?)"/i
      if match
        out[key] = match[1]
      else
        try
          out[key] = parseFloat val
        catch err
          out[key] = val
    cb out

getInterface = ->
  dbus.init()
  session = dbus.session_bus()
  return dbus.get_interface session, "org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2", "org.mpris.MediaPlayer2.Player"

module.exports =
  meta:
    name: "spotify"
    author: "Contra"
    version: "0.0.1"
    description: "Spotify controls/information"

  next: (done) ->
    getInterface().Next()
    done success: true

  previous: (done) ->  
    getInterface().Previous()
    done success: true

  toggle: (done) -> 
    getInterface().PlayPause()
    done success: true
    
  pause: (done) -> 
    getInterface().Pause()
    done success: true

  play: (done) -> 
    getInterface().Play()
    done success: true

  stop: (done) -> 
    getInterface().Stop()
    done success: true

  open: (done, uri) ->
    getInterface().OpenUri uri
    done success: true

  playing: (done) ->
    getMeta (meta) ->
      meta.contentCreated = new Date meta.contentCreated
      done meta