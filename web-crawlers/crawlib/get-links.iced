request = require 'request'
cheerio = require 'cheerio'

# Retrieve all the links of a url.

getLinks = (url, callb)->
	# linksMap, linksFilter, etc...
	res = []
	await request url, defer err, resp, html
	return console.log err if err
	$ = cheerio.load html
	$('a').each (i, e)=>
		ref = $(e).attr 'href'
		res.push ref
	callb res

module.exports = getLinks
