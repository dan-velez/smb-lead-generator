# Perform a breadth first search on a website for links.
# Run a function at each link found.

makeUrl = require './make-url.iced'
getLinks = require './get-links.iced'
# sleep = require './sleep.iced'

bfs = ({ root, path, visit, linkP, done, speed, control })->

	# Map function visit to all connected nodes.
	# linkP (optional) is tested against links to proceed.
	# running determines when to stop the crawler.

	queue = []
	visited = {}
	queue.push path
	
	while queue.length
		break if not control.run
		# if speed then await sleep 1000, defer()
		node = queue.shift()
		continue if visited[node]
		visited[node] = true
		visit root:root, path:node
		url = makeUrl root, node
		await getLinks url, defer links
		for link in links
			continue if not link
			continue if link.startsWith 'http'
			continue if visited[link]
			if linkP
				continue if not linkP link
			queue.push link

	done()

module.exports = bfs

#-----------------------------#
###
out = console.log
bfs
	root: 'http://yellowpages.com'
	path: '/search?search_terms=shoes&geo_location_terms=miami'
	visit: ({ root, path })-> out 'visiting', path
	control: run:true
	done: ->
	linkP: (l)->
		l and l.includes('search') or l.includes('mip')
		and not l.includes 'auth'
###
