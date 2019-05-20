# Filter a single link for the google crawler

filterLink = (l, visited)->
	return false if not l.includes 'start='
	page = extractPage l
	if not visited[page]
		visited[page] = true
		return true
	return false

extractPage = (str)->
	str = str.slice str.indexOf 'start='
	str = str.substring 0, str.indexOf '&'
	str = str.slice str.indexOf('=')+1
	str

module.exports = filterLink
