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

  total: (done, format="raw") ->
    if format is "raw"
      done os.totalmem()
    else if format is "pretty"
      done readableSize os.totalmem()
    else
      throw "Invalid format specified"

  free: (done, format="raw") ->
    if format is "raw"
      done os.freemem()
    else if format is "pretty"
      done readableSize os.freemem()
    else
      throw "Invalid format specified"

  used: (done, format="raw") ->
    used = os.totalmem()-os.freemem()
    if format is "raw"
      done used
    else if format is "pretty"
      done readableSize used
    else
      throw "Invalid format specified"