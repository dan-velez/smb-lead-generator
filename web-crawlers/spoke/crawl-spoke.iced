# spoke.com crawler -------------------------------------------#

bfsJS = require '../crawlib/bfs-js.iced'
parseEmails = require '../crawlib/parse-emails.iced'
parseNums = require '../crawlib/parse-phone-numbers.iced'
parsePage = require './parse-page.iced'
cheerio = require 'cheerio'
{ EventEmitter } = require 'events'

crawlSpoke = ({ term })->
	emitter = new EventEmitter

	# Keep track of comapnies and pages domain specific.
	visited = {}

	control = running:true

	bfsJS
		root: 'http://spoke.com'
		path: "/search?q=#{ term }"
		control: control
		delay: 1000

		parse: ({ html, url })->
			parsePage { html, url, emitter, visited }

		filter: (l)->
			l.includes('page') or l.includes('companies') and
			not l.includes('edit') and
			not l.includes('name')

	# Return the observer for listeners
	emitter.stop = -> control.running = false
	emitter

module.exports = crawlSpoke

#-- test program ----------------------------------------------#
###
crawler = crawlSpoke
	term: 'software'

crawler.on 'log', (log)->
	console.log log

crawler.on 'lead', (lead)->
	console.log '\n'
	console.log '>>> lead found <<<'
	console.log lead:lead
	console.log '\n'
###
