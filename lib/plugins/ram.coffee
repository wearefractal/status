os = require "os"
{readableSize} = require "../util"

module.exports =
  meta:
    name: "ram"
    author: "Contra"
    version: "0.0.1"
    description: "RAM information"

  total: (done, format="raw") ->
    total = os.totalmem()
    if format is "raw"
      done total
    else if format is "pretty"
      done readableSize total
    else
      throw "Invalid format specified"

  free: (done, format="raw") ->
    free = os.freemem()
    if format is "raw"
      done free
    else if format is "pretty"
      done readableSize free
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