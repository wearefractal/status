module.exports =
  meta:
    name: "node"
    author: "Contra"
    version: "0.0.1"
    description: "Node information"

  version: (done) -> done process.versions
  environment: (done) -> done process.env.NODE_ENV
  prefix: (done) -> done process.installPrefix