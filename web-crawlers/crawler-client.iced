# Web crawler service client.

io = require 'socket.io-client'
crawler = 'http://localhost:5000'
# crawler = 'http://ebizfi-crawlerserver.herokuapp.com'
out = console.log

client = io crawler

client.on 'connect', ->
	out 'connected'
	client.emit 'search',
		source: 'all-biz.com'
		state: 'FL'
		term: 'Trucks'

client.on 'log', (packet)->
	out 'log packet recieved', packet

client.on 'lead', (packet)->
	out '\n'
	out 'lead recieved', packet
	out '\n'
