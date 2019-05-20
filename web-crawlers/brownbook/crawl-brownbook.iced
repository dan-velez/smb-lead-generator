# Crawl http://brownbook.net for leads.

bfsJS = require '../crawlib/bfs-js-0.1.0.iced'
parsePage = require './parse-page.iced'

# Keep an array of visited business names.
visited = {}

{ EventEmitter } = require 'events'

crawlBrownbook = ( {term} )->
	emitter = new EventEmitter
	control = running:true
	bfsJS
		root: "http://www.brownbook.net/businesses/#{term}"
		path: '/'
		control: control

		parse: ({ html, url, node })->
			console.log 'parse called...'
			emitter.emit 'log', log:"visiting #{url}"
			parsePage { emitter, html, url, node }

		filter: (l)->
			# console.log '!>', l
			# l = l.split '/'
			# name = extractName l
			# only pagees (p=n)
			# pages in the back have less emails.
			# find a link to another search or create one.
			pass = (l.includes('tag='))
			pass
	emitter.stop = -> control.running = false
	emitter

module.exports = crawlBrownbook
# test program ------------------------------------------------#
###
ref = crawlBrownbook term:'trucking'
ref.on 'lead', (l)-> console.log lead:l
ref.on 'log', (l)-> console.log log:l
###
