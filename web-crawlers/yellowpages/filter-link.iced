# Filter a single link to be followed 
# for http://yellowpages.com crawler.

extractName = require './extract-name.iced'

visited = {}

filterYellowpagesLink = (l)->
	links = l.split '/'
	name = links[links.indexOf('mip')+1]
	if name
		name = name.trim().replace /\s{2,}/g, ''
		name = extractName name
		if name.length > 1
			if visited[name] then return false
			visited[name] = true
			# console.log 'parsed name for filter', name
			return true
	else if l.includes 'search'
		return true
	else return false

module.exports = filterYellowpagesLink
