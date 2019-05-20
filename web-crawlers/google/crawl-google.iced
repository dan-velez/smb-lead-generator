# Crawl http://google.com for leads.

parsePath = require './parse-path.iced'
parsePage = require './parse-page.iced'
filter = require './filter-link.iced'
bfs = require '../crawlib/bfs-js.iced'
{ EventEmitter } = require 'events'

crawlGoogle = ({ term, location })->
	# Keep track of all visited search pages to avoid backtracking.
	visited = {}

	# Use this emitter to talk to the web socket server.
	emitter = new EventEmitter

	url = parsePath { term, location }
	console.log 'url is', url

	control =
		running: true

	bfs
		root: 'http://google.com'
		path: parsePath { term, location }
		delay: 3000
		
		# Control the flow of the function with this variable.
		# Otherwise the function will crawl until its queue is empty.
		control: control

		parse: ({html, url})->
			# Retrieve leads from page using an external function.
			emitter.emit 'log', log:"visit #{url}"
			parsePage {emitter, html, url }
		
		filter: (l)->
			filter l, visited

	emitter.stop = -> control.running = false
		
	emitter

module.exports = crawlGoogle

# test program *************************************************
###
crawler = crawlGoogle
	term: 'software'
	location: 'Miami'

crawler.on 'log', (l)-> console.log log:l
crawler.on 'lead', (l)-> console.log lead:l
###
