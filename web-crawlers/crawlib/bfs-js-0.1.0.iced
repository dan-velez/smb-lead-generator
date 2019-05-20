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
		console.log 'queue length', queue.length
		return if not control.running
		# if delay then await sleep delay, defer()
		node = queue.shift()
		
		# Make the url to visit
		url = "#{root}#{node}"

		await requestz url, defer html, headers
		console.log 'brown.net request returned'
		console.log headers
		if parse
			console.log 'can parse...'
			parse { html, url, node }
		console.log 'parse completed...'

		# Retrieve links and decide on which ones to follow.
		links = parseLinks html

		console.log 'parsed links completed...'
		console.log 'links found', links

		links = links.filter (l)-> not l.includes 'http'
		links = links.filter (l)-> not visited[l]

		if filter then links = links.filter filter

		console.log 'links filtered'

		for link in links
			if not visited[link]
				console.log 'adding link', link
				queue.push link
				visited[link] = true

	console.log '!!! bfs queue is empty'

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
