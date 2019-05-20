# Parse a search query for truckingdatabase.com

parsePath = ({ state, city })->
	"/companies/#{state}/#{city}"

module.exports = parsePath
