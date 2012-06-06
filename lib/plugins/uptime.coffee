status = require '../../'

module.exports =
  name: 'uptime'
  author: 'Contra'
  version: '0.0.1'

  # Sample data: " 05:38:24 up  1:44,  0 users,  load average: 1.05, 1.06, 0.96"
  total: (done, format="raw") ->
    done "05:38:24"