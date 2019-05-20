# Parse a search query for google crawler.

parsePath = ({ term, location })->
	"/search?q=#{location.split(/\s+/g).join '+'}" +
	"+#{term.split(/\s+/g).join '+'}" +
	"+email"

module.exports = parsePath
