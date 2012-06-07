os = require "os"
{readableSize} = require "../util"

module.exports =
  meta:
    name: "ram"
    author: "Contra"
    version: "0.0.1"
    description: "RAM information"

  usage: (done, format="raw") ->
    total = os.totalmem()
    free = os.freemem()
    used = total-free

    if format is "raw"
      done
        total: total
        used: used
        free: free
    else if format is "pretty"
      done
        total: readableSize total
        used: readableSize used
        free: readableSize free
    else
      throw "Invalid format specified"