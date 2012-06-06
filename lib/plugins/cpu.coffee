{exec} = require "child_process"
os = require "os"
{readableSpeed, calculateCPU} = require "../util"

module.exports =
  meta:
    name: "cpu"
    author: "Contra"
    version: "0.0.1"
    description: "CPU information"

  temp: (done, format="raw") ->
    # TODO: implement

  usage: (done, format="raw") ->
    cpus = os.cpus()
    if format is "raw"
      done (calculateCPU cpu.times for cpu in cpus)
    else if format is "pretty"
      # TODO: implement properly
      done (calculateCPU cpu.times, true for cpu in cpus)
    else
      throw "Invalid format specified"

  speed: (done, format="raw") ->
    cpus = os.cpus()
    if format is "raw"
      done (cpu.speed for cpu in cpus)
    else if format is "pretty"
      done (readableSpeed cpu.speed for cpu in cpus)
    else
      throw "Invalid format specified"