## Information

<table>
<tr>
<td>Package</td><td>shake</td>
</tr>
<tr>
<td>Description</td>
<td>Deployment tool for node</td>
</tr>
<tr>
<td>Node Version</td>
<td>>= 0.4</td>
</tr>
</table>

## Usage

### Running tasks
```$ shake setup:deploy:something:status:somethingelse```

### Defining tasks
Add a .roco.coffee or .roco.js file to your project root.

Here is an example config demonstrating basic functionality:

```coffee-script
shake = require 'shake'

# This is a non-standard config used only within this config
# you can make this file look like whatever you want as long as you export
# your tasks and target
app =
  sudo: "sudo" # Change this to "" to disable sudo
  parent: '/var/www/'
  name: 'your cool app name'
app.repository = "git@github.com:your cool username/#{app.name}.git"
app.folder = "#{app.parent}#{app.name}/"
app.start = "coffee #{app.folder}start.coffee"
app.log = "/var/log/#{app.name}.log"


module.exports =
  target: 'your cool server'
  clean: (local, remote, done) ->
    remote.exec """
    #{app.sudo} rm -rf #{app.folder}
    """, done

  setup: (local, remote, done) ->
    remote.exec """
    NAME=`whoami`;
    #{app.sudo} mkdir -p #{app.folder}
    #{app.sudo} chown -R $NAME:$NAME #{app.folder}
    git clone #{app.repository} #{app.folder}
    cd #{app.folder}
    npm install
    """, done

  deploy: (local, remote, done) ->
    remote.exec """
    cd #{app.folder}
    git pull
    sudo killall node
    npm install
    #{app.sudo} stop #{app.name}
    #{app.sudo} start #{app.name}
    """, done

  start: (local, remote, done) ->
    remote.exec "#{app.sudo} start #{app.name}", done

  stop: (local, remote, done) ->
    remote.exec "#{app.sudo} stop #{app.name}", done

  restart: (local, remote, done) ->
    remote.exec "#{app.sudo} restart #{app.name}", done

  log: (local, remote, done) ->
    remote.exec "tail -n 100 #{app.log}", done

  status: (local, remote, done) ->
    remote.exec "ps -eo args | grep '#{app.name}' | grep -v grep", (err, res) ->
      done err, if res then "Online" else "Offline"
```

### Task API

A task is a function that takes 3 arguments.

```coffee-script
module.exports =
  sometask: (local, remote, done) ->
    local.exec "whoami", (err, res) ->
      # err = stderr
      # res = stdout
    local.run "whoami", "ls -la", (err, res) ->
      # err = array of errors
      # res = array of responses
      # .run is for executing multiple commands where you need the response

    local.exec """
    whoami
    ls -la
    mkdir test
    """, (err, res) ->
      # err = stderr for all commands
      # res = stdout for all commands
      # .exec will handle multiple commands if you don't care about the result

      done err, res # Call this when the task is finished - logs its arguments
```

## LICENSE

(MIT License)

Copyright (c) 2012 Fractal <contact@wearefractal.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
