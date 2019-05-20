# A web crawler that uses a dfs search algorithm implemented
# via a stack. It is currently not usable.

dfsStack = ({ root, path, visit })->
	stack = []
	visited = {}
	stack.push path
	while stack.length
		node = stack[stack.length-1]
		visited[node] = true
		out 'stack peak', node
		await getLinks makeUrl(root, path), defer links
		if not links then stack.pop() # Pop to unvisited
		for link in links
			if link and not visited[link]
				stack.push link
				visited[link] = true

module.exports = dfsStack