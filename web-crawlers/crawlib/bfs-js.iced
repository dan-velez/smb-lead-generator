# Breadth first search web crawler that renders pages with JS.

requestz = require '../requestz.iced'
parseLinks = require '../crawlib/parse-links.iced'
sleep = require '../crawlib/sleep.iced'
makeUrl = require './make-url.iced'

bfsJS = ({ root, path, filter, parse,
	delay, control, header })->

	queue = []
	visited = {}
	queue.push path

	while queue.length
		return if not control.running
		if delay then await sleep delay, defer()
		node = queue.shift()
		url = makeUrl root, node
		await requestz url, defer html
		if parse and html then parse { html, url, node }

		# Retrieve links and decide on which ones to follow.
		links = parseLinks html

		links = links.filter (l)-> not l.includes 'http'
		links = links.filter (l)-> not visited[l]

		if filter then links = links.filter filter

		for link in links
			if not visited[link]
				queue.push link
				visited[link] = true

module.exports = bfsJS
# test program ------------------------------------------------#
###
parseEmails = require './parse-emails.iced'

extractName = (path)->
	path.split('/')[3]

visited = {}

bfsJS
	root: 'http://google.com'
	path: '/search?q=miami+software+email'
	control: running:true

	parse: ({ html, url })->
		console.log 'visiting', url
		emails = parseEmails html
		if emails
			for email in emails
				console.log '\n'
				console.log 'lead found'
				console.log { email }

	filter: (l)->
		true
###
