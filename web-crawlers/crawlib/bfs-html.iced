# More efficient bfs. Makes only one request and passes
# an html string to its functions.

request = require 'request'
makeUrl = require './make-url.iced'
parseLinks = require './parse-links.iced'
sleep = require './sleep.iced'

bfsHtml = ({
	root		# Root domain.
	start		# Start path in domain.
	parse		# Run for each html page fetched.
	filter	# Filter links to follow with this callback.
	delay		# Between requests in (ms).
	control # Controls wether the function should exit.
	headers # A callback that takes the
					# headers of the page being visited.
	})->

	# running = true
	visited = {}
	queue = []
	queue.push start

	while queue.length
		return if not control.running
		if delay then await sleep delay, defer()
		path = queue.shift()
		url = makeUrl root, path
		await request url, defer err, resp, body

		# Run callback functions on response.
		if err
			console.error err
			continue
		if headers then headers resp.headers
		if parse then parse { html:body, url }

		# Get links from body.
		links = parseLinks body
		continue if not links

		# Remove links not needed to follow.
		links = links.filter (l)-> not l.startsWith 'http'
		if filter then links = links.filter filter

		# Add links to queue.
		for link in links
			if not visited[link]
				visited[link] = true
				queue.push link

module.exports = bfsHtml

# ------------------------------------------------------------ #
# Test program

###
parseEmails = require './parse-emails.iced'
out = console.log

bfsHtml
	root: 'https://www.spoke.com'
	start: '/'

	parse: ({html, url})->
		out 'visiting', url
		out 'body is', html
		emails = parseEmails html
		if emails then console.log emails

	filter: (l)->
		true

	headers: (h)->
		console.log 'headers', h, '\n\n'

	control: running:true
###

# ------------------------------------------------------------ #
