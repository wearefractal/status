CLI
  * Better documentation
  * Allow reading input from stdin
  * Allow users to do post-run JSON selects
    * Example: status os uptime.hours == {"uptime":20}
    * Example: status os uptime.hours -p == 20
    * Example: status os cpus[0] == {"cpus":"Intel i7"}
    * Example: status spotify.playing.artist == {"playing":"Ratatat"}
    * Example: status os disks[0].usage.free

Plugins
  * Allow operations to get the value of the previous
  * Allow plugins to return plugins recursively

Web Server
  * Server
  * Client
  * Websockets via Vein?