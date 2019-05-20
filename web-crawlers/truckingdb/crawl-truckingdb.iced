# Crawl http://truckingdatabase.com.
# input: STATE, CITY
# The function can modify itself through callbacks.

parsePath = require './parse-path.iced'
parsePage = require './parse-page.iced'
bfs = require '../crawlib/bfs-html.iced'
{ EventEmitter } = require 'events'

crawlTruckingdb = ({ state, city })->
	url = parsePath { state, city }
	console.log 'url is', url

	# Use this emitter to broadcast leads found.
	emitter = new EventEmitter

	control =
		running: true

	bfs
		root: 'http://truckingdatabase.com'
		start: parsePath { state, city }
		delay: 1000
		
		# Control the flow of the function with this variable.
		# Otherwise the function will crawl until its queue is empty.
		control: control

		parse: ({html, url})->
			# Retrieve leads from page using an external function.
			emitter.emit 'log', log:"visit #{url}"
			parsePage {emitter, html, url }

		filter: (l)->
			# Only get links that include `dot`, which indicates
			# this url is a company link.
			l.includes 'dot'

	emitter.stop = -> control.running = false
		
	emitter

module.exports = crawlTruckingdb

#** test program ***********************************************
###

crawler = crawlTruckingdb
	state: 'FL'
	city: 'TAMPA'
crawler.on 'log', (log)-> console.log log:log
crawler.on 'lead', (lead)-> console.log lead:lead

setTimeout (->
	console.log 'stop crawler'
	crawler.stop()
	), 6000
###
