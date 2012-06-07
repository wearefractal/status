{readFile} = require "fs"
{readableSize} = require '../util'

module.exports =
  meta:
    name: "network"
    author: "Contra"
    version: "0.0.1"
    description: "Network information"

  upstream: (done, int="eth0", format="raw") ->
    readFile "/sys/class/net/#{int}/statistics/tx_bytes", (err, res) ->
      val = parseInt res
      if format is "raw"
        done val
      else if format is "pretty"
        done readableSize val
      else
        throw "Invalid format specified"

  downstream: (done, int="eth0", format="raw") ->
    readFile "/sys/class/net/#{int}/statistics/rx_bytes", (err, res) ->
      val = parseInt res
      if format is "raw"
        done val
      else if format is "pretty"
        done readableSize val
      else
        throw "Invalid format specified"