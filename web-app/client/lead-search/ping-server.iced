# Keep a connection alive by periodically pinging it.

ping = (conn)->
	setInterval (->
		conn.emit 'keepalive', keepalive:'*'
	), 20000

module.exports = ping
