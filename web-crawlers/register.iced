# Register a client to crawler messaging service.
# Add a listener for service requests and run service
# using a runner function.

runSearch = require './run-search.iced'

register = (client)->
	console.log 'new client connection', client.id

	# Listen for keep alive requests.
	client.on 'keepalive', (packet)-> console.log 'ping - keep alive'

	# Pass the client to the search runner.
	client.on 'search', (packet)-> runSearch client, packet

module.exports = register
