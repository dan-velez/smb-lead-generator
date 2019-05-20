# Retrieve all the links from the body of an html docment.

cheerio = require 'cheerio'

parseLinks = (html)->
	links = []
	$ = cheerio.load html
	$('a').each (i, e)->
		link = $(e).attr 'href'
		if link then links.push link
	links

module.exports = parseLinks
