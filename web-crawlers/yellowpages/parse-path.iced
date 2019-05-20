# Parse path for yellowpages search query.

parsePath = ({ term, location })->
	"/search?search_terms=" +
	"#{term.split(/\s+/g).join '%20'}" +
	"&geo_location_terms=" +
	"#{location.split(/\s+/g).join '%20'}"

module.exports = parsePath
