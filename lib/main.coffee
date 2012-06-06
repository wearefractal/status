semver = require "semver"
Plugin = require "./Plugin"
{join} = require "path"
{readdirSync} = require "fs"

plugins = {}

status =
  run: (name, args..., cb) ->
    return cb "Plugin #{name} is not installed" unless plugins[name]?
    plugins[name].run args, cb

  list: -> plugins
  remove: (name) -> delete plugins[name]
  load: (plugin) ->
    return "Invalid plugin: Plugin must be an object" unless typeof plugin is "object"

    # Validate that plugin data exists
    return "Invalid plugin: Missing meta field" unless typeof plugin.meta is "object"
    {name, author, version} = plugin.meta
    return "Invalid plugin: Missing name field" unless typeof name is "string" and name.length > 0
    return "Invalid plugin: Missing author field" unless typeof author is "string" and author.length > 0
    return "Invalid plugin: Missing version field" unless typeof version is "string" and version.length > 0
    return "Invalid plugin: Name must be alphanumeric" unless name.match /^\w+$/

    # Clean data
    version = semver.clean version
    author = author.trim()
    name = name.trim()

    return "Invalid plugin: Invalid version field" unless semver.valid version
    return "Plugin #{name} already exists" if plugins[name]?

    # Load plugin
    try
      plugins[name] = new Plugin plugin
    catch e
      return e.message or e

    return true

pluginDir = join __dirname, "./plugins"
status.load require join(pluginDir, file) for file in readdirSync pluginDir

module.exports = status