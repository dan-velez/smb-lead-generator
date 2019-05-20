# A websocket server for a  web crawler service.

express = require 'express'
cors = require 'cors'
io = require 'socket.io'
http = require 'http'
register = require './register.iced'

# Log heap snapshots.
debug = require './debug.iced'

setupServer = ->

	# Start an express server and register clients  using
	# the `register` function.

	app = express()
	app.use cors()
	server = http.Server app
	wss = io server
	wss.on 'connection', register
	port = process.env.PORT or 3000
	server.listen port, ->
		console.log 'crawler service <--->', port

setupServer()
