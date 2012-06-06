semver = require "semver"
Plugin = require "./Plugin"
{join} = require "path"
{readdirSync} = require "fs"

plugins = {} # Keep out of reach so people have to use loadPlugin/removePlugin

status =
  loadDefaults: ->
    pluginDir = join __dirname, "./plugins"
    status.loadPlugin require join(pluginDir, file) for file in readdirSync pluginDir
    return

  getPlugins: ->
    out = {}
    out[k]=v for k,v of plugins
    return out

  removePlugin: (name) -> delete plugins[name]
  loadPlugin: (plugin) ->
    return "Invalid plugin: Plugin must be an object" unless typeof plugin is "object"

    # Validate that plugin data exists
    {name, author, version} = plugin
    return "Invalid plugin: Missing name field" unless typeof name is "string" and name.length > 0
    return "Invalid plugin: Missing author field" unless typeof author is "string" and author.length > 0
    return "Invalid plugin: Missing version field" unless typeof version is "string" and version.length > 0
    return "Invalid plugin: Name must be alphanumeric" unless name.match /^\w+$/

    # Clean data
    version = semver.clean version
    author = author.trim()

    return "Invalid plugin: Invalid version field" unless semver.valid version
    return "Plugin '#{name}' already exists" if plugins[name]?

    # Load plugin
    try
      plugins[name] = new Plugin plugin
    catch e
      return e.message

    return true

module.exports = status