{exec} = require "child_process"
util = require '../util'

runNm = (fields, cb) ->
  throw "nmcli not installed" unless util.which "nmcli"
  exec "nmcli -t -f active,#{fields} dev wifi", (err, stdout) ->
    throw err if err? 
    cb (line for line in stdout.split('\n') when line.indexOf("yes") is 0)[0]

module.exports =
  meta:
    name: "wireless"
    author: "Contra"
    version: "0.0.1"
    description: "Wireless network information"

  ssid: (done) ->
    runNm "ssid", (activeline) ->
      ssid = activeline[activeline.indexOf("'")+1...activeline.lastIndexOf("'")]
      done ssid

  bssid: (done) ->
    runNm "bssid", (activeline) ->
      [head, bssid...] = activeline.replace(/\\/g,'').split ':'
      done bssid.join ':'

  # TODO: pretty format for signal, freq, and rate
  signal: (done) ->
    runNm "signal", (activeline) ->
      done parseInt activeline.split(':')[1]

  frequency: (done) ->
    runNm "freq", (activeline) ->
      done parseInt activeline.split(':')[1].split(' ')[0]

  rate: (done) ->
    runNm "rate", (activeline) ->
      done parseInt activeline.split(':')[1].split(' ')[0]

  security: (done) ->
    runNm "security", (activeline) ->
      done activeline.split(':')[1]

  mode: (done) ->
    runNm "mode", (activeline) ->
      done activeline.split(':')[1]