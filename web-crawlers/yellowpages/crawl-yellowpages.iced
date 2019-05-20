# Crawl http://yellowpages.com for leads.

parsePath = require './parse-path.iced'
parsePage = require './parse-page.iced'
filter = require './filter-link.iced'
bfs = require '../crawlib/bfs-html.iced'
{ EventEmitter } = require 'events'

crawlYellowpages = ({ term, location })->
	# Keep track of all visited business names. Some have multiple url's.
	visited = {}

	# Use this emitter to talk to the web socket server.
	emitter = new EventEmitter

	url = parsePath { term, location }
	console.log 'url is', url

	control =
		running: true

	bfs
		root: 'http://yellowpages.com'
		start: parsePath { term, location }
		# delay: 1000
		
		# Control the flow of the function with this variable.
		# Otherwise the function will crawl until its queue is empty.
		control: control

		parse: ({html, url})->
			# Retrieve leads from page using an external function.
			emitter.emit 'log', log:"visit #{url}"
			parsePage {emitter, html, url }
		
		filter: filter

	emitter.stop = -> control.running = false
		
	emitter

module.exports = crawlYellowpages

# test program *************************************************
###
crawler = crawlYellowpages
	term: 'shoes'
	location: 'Miami'

crawler.on 'log', (l)-> console.log log:l
crawler.on 'lead', (l)-> console.log lead:l
###
