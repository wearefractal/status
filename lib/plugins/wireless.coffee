{exec} = require "child_process"
util = require '../util'

throw "nmcli not installed" unless util.which "nmcli"

module.exports =
  meta:
    name: "wireless"
    author: "Contra"
    version: "0.0.1"
    description: "Wireless network information"

  ssid: (done) ->
    exec "nmcli -t -f active,ssid dev wifi", (err, stdout, stderr) ->
      throw err if err?
      [activeline] = (line for line in stdout.split('\n') when line.indexOf("yes") is 0)
      ssid = activeline[activeline.indexOf("'")+1...activeline.lastIndexOf("'")]
      done ssid

  bssid: (done) ->
    exec "nmcli -t -f active,bssid dev wifi", (err, stdout, stderr) ->
      throw err if err?
      [activeline] = (line for line in stdout.split('\n') when line.indexOf("yes") is 0)
      activeline = line.replace '\\:', '-'
      done activeline.split(':')[1]

  # TODO: pretty format for signal, freq, and rate
  signal: (done) ->
    exec "nmcli -t -f active,signal dev wifi", (err, stdout, stderr) ->
      throw err if err?
      [activeline] = (line for line in stdout.split('\n') when line.indexOf("yes") is 0)
      done parseInt activeline.split(':')[1]

  frequency: (done) ->
    exec "nmcli -t -f active,freq dev wifi", (err, stdout, stderr) ->
      throw err if err?
      [activeline] = (line for line in stdout.split('\n') when line.indexOf("yes") is 0)
      done parseInt activeline.split(':')[1].split(' ')[0]

  rate: (done) ->
    exec "nmcli -t -f active,rate dev wifi", (err, stdout, stderr) ->
      throw err if err?
      [activeline] = (line for line in stdout.split('\n') when line.indexOf("yes") is 0)
      done parseInt activeline.split(':')[1].split(' ')[0]

  security: (done) ->
    exec "nmcli -t -f active,security dev wifi", (err, stdout, stderr) ->
      throw err if err?
      [activeline] = (line for line in stdout.split('\n') when line.indexOf("yes") is 0)
      done activeline.split(':')[1]

  mode: (done) ->
    exec "nmcli -t -f active,mode dev wifi", (err, stdout, stderr) ->
      throw err if err?
      [activeline] = (line for line in stdout.split('\n') when line.indexOf("yes") is 0)
      done activeline.split(':')[1]