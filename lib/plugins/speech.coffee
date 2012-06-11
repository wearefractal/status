{exec} = require "child_process"
{which} = require "fractal"

module.exports =
  meta:
    name: "speech"
    author: "Joseph"
    version: "0.0.1"
    description: "text to speech using festival"

  speak: (done, text)->
    throw 'festival is not installed' unless which 'festival'
    throw 'echo is not installed' unless which 'echo'
    exec "echo #{text} | festival --tts", (err, stdout)->
      throw err if err
      done {spoke: text}