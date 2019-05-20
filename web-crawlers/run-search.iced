# Run a search request for a client and redirect output to
# the client's socket.

# Import available crawlers
crawlers = require './crawler-list.iced'

runSearch = (client, packet)->
	console.log 'run search', packet

	# Get the crawl function.
	crawl = crawlers[packet.source]

	if not crawl
		return client.emit 'log', error:'source unavaiable'

	client.emit 'log'
	, log:"run-search #{packet.source} #{new Date}"

	crawler = crawl packet
	crawler.on 'log', (l)-> client.emit 'log', l
	crawler.on 'lead', (l)-> client.emit 'lead', l

	stopCrawler = ->
		console.log 'stopping crawler', "#{client.id}:#{packet.source}"
		crawler?.stop()
		crawler?.removeAllListeners()
		client?.removeAllListeners 'stop'
		crawler = null
		client.emit 'log'
		, log:"Crawler stopped #{packet.source} #{new Date}"
	
	# Stop crawler at events.
	client.on 'disconnect', stopCrawler
	client.on 'stop', stopCrawler

module.exports = runSearch
