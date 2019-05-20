# Parse a path for crawling kijiji.

parsePath = ({ term })->
	"/b-canada/#{term}/k0l0"

module.exports = parsePath
