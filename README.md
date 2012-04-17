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
```$ shake setup:deploy:something["some arg", true, 2]:status```

### Defining Tasks

Add a .shake.coffee or .shake.js file to your project root.

A task is a function that takes 3 arguments. Any arguments inside [ and ] will be applied to the task function after the initial 3.

```coffee-script
module.exports =
  sometask: (local, remote, done) ->
    # local = local machine
    # remote = remote machine (defined in target)
    local.exec """
    whoami
    ls -la
    mkdir test
    """, (res) ->
      # res = array of stdout+stderr
      remote.exec "ls -la", (res) ->
        done() # Call this when the task is finished
```

### Example config
Here is an example config demonstrating basic functionality:

```coffee-script
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
  target: 'cool server'
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
    remote.sexec "ps -eo args | grep '#{app.name}' | grep -v grep", (res) ->
      done if res then "Online" else "Offline"
```