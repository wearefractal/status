os = require "os"

module.exports =
  meta:
    name: "os"
    author: "Contra"
    version: "0.0.1"

  arch: (done) -> done os.arch()
  platform: (done) -> done os.platform()
  type: (done) -> done os.type()
  hostname: (done) -> done os.hostname()
  cpus: (done) -> done os.cpus()
  kernel: (done) -> done os.release()