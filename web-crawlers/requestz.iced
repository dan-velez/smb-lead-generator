# Request a web page with rendered JavaScript.

Browser = require 'zombie'

requestz = (url, callb)->
	browser = new Browser
	browser.fetch url
	.then (resp)->
		# console.log resp.headers
		return resp.text()
	.then (text)->
		# console.log 'resp body', text
		callb text, headers:{}

module.exports = requestz


### test program
requestz("http://www.all-contractors.com/contractors-and-builders-in-New+York_NY", (text, headers)-> console.log text)
###