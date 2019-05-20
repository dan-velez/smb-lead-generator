# Crawl http://kijiji.com for leads.

parsePath = require './parse-path.iced'
parsePage = require './parse-page.iced'
# filter = require './filter-link.iced'
bfs = require '../crawlib/bfs-html.iced'
{ EventEmitter } = require 'events'

crawlKijiji = ({ term })->
	visited = {}

	emitter = new EventEmitter

	url = parsePath { term }

	control =
		running: true

	console.log 'starting @', url

	bfs
		root: 'http://kijiji.com'
		start: parsePath { term }
		
		control: control

		parse: ({html, url})->
			emitter.emit 'log', log:"visit #{url}"
			parsePage {emitter, html, url }
		
		filter: (l)->
			l.includes term

	emitter.stop = -> control.running = false
		
	emitter

module.exports = crawlKijiji

# test program *************************************************
crawler = crawlKijiji
	term: 'software'

crawler.on 'log', (l)-> console.log log:l
crawler.on 'lead', (l)-> console.log lead:l
