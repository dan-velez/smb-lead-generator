# A web crawler implementation using depth first search.
# Be careful.

dfs = ({root, path, visit, linkP, speed})->
	visited ={}
	i = 0

	dfsclj = ({ root, path, visit })->
		visit { root:root, path:path }
		url = "#{root}#{path}"
		await getLinks url, defer links
		# if linkP then links = links.filter linkP
		links.map (link)->
			return if not link
			return if visited[link]
			if linkP
				return if not linkP link
			visited[link] = true
			await sleep speed, defer()
			dfsclj {root:root, path:link, visit:visit}

	dfsclj {root:root, path:path, visit: visit}

module.exports = dfs