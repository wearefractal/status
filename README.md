![status](https://secure.travis-ci.org/wearefractal/status.png?branch=master)

## Information

<table>
<tr>
<td>Package</td><td>status</td>
</tr>
<tr>
<td>Description</td>
<td>System automation on steroids</td>
</tr>
<tr>
<td>Node Version</td>
<td>>= 0.6</td>
</tr>
</table>

## Introduction

Shh... It's okay - everything is going to be alright. status is here to make all of your nightmares go away.

status provides a flexible JSON interface on top of any commands/tasks/sensors/signals/hardware/etc you want to automate. status operations can be run locally (via the CLI) or remotely (via the REST server).

## Usage

### Command Line

```javascript
// Specify a plugin and the output you want back
// In this example I specify the 'uptime' plugin with the 'total' operation
$ status os uptime
{"total":{"hours":7,"minutes":40,"seconds":6}}

// You can pass arguments to operations too!
// Arguments can be any javascript objects separated by commas
$ status processes grep["skype"]
{"grep":[{"id":1234, "name":"skype"}]}

// Chaining operations will run them asynchronously
$ status cpu temp:usage:speed
{"temp":107.6, "usage":10, "speed":2100}

// Combine them all and have fun!
$ status cpu temp["celsius"]:usage["total","mhz"]:speed["ghz"]
{"temp":42, "usage":100, "speed":2.1}
```

### REST API

```javascript
// Specify a plugin and the output you want back
// In this example I specify the 'uptime' plugin with the 'total' operation
POST /status/os "uptime"
{"total":{"hours":7,"minutes":40,"seconds":6}}

// You can pass arguments to operations too!
// Arguments can be any javascript objects separated by commas
POST /status/processes "grep['skype']"
{"grep":[{"id":1234, "name":"skype"}]}

// Chaining operations will run them asynchronously
POST /status/cpu "temp:usage:speed"
{"temp":107.6, "usage":10, "speed":2100}

// Combine them all and have fun!
POST /status/cpu "temp['celsius']:usage['total','mhz']:speed['ghz']"
{"temp":42, "usage":100, "speed":2.1}
```

## Included Plugins

```
cpu@0.0.1 - CPU information
  * temp
  * usage
  * speed
spotify@0.0.1 - Spotify controls/information
  * next
  * previous
  * toggle
  * pause
  * play
  * stop
  * open
  * playing
processes@0.0.1 - Process information
  * all
  * mine
  * grep
  * top
network@0.0.1 - Network information
  * upstream
  * downstream
wireless@0.0.1 - Wireless network information
  * ssid
  * bssid
  * signal
  * frequency
  * rate
  * security
  * mode
hd@0.0.1 - Hard Disk information
  * temp
  * usage
  * total
  * free
  * used
daemons@0.0.1 - Daemon management through rc.d
  * list
  * started
  * stopped
  * auto
  * noAuto
  * start
  * stop
  * restart
  * status
ram@0.0.1 - RAM information
  * usage
  * total
  * free
  * used
os@0.0.1 - System information
  * load
  * uptime
  * arch
  * platform
  * type
  * hostname
  * kernel
  * environment
  * drives
  * cpus
  * network
node@0.0.1 - Node information
  * version
  * environment
  * prefix
speech@0.0.1 - text to speech using festival
  * speak
```

## Writing Plugins

Let's write a plugin called "coolkern" that returns the kernel version

```coffee-script
{exec} = require "child_process"

coolkern =
  meta:
    name: "coolkern"
    author: "YOU"
    version: "0.0.1"

  version: ->
    exec "uname -r", (err, stdout) =>
      @done stdout
```

Simple enough, right? Now add it to status

```coffee-script
status = require 'status'
status.load coolkern
```

Finished! Now you can test it out

```
$ status kernel version
{"version":"3.3.7-1-ARCH"}
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