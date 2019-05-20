# Index file to import functions from this module.
# Import crawling modules.

getLinks = require './get-links.iced'
parseEmails = require './parse-emails.iced'
crawlBfs = require './crawl-bfs.iced'
sleep = require './sleep.iced'

module.exports =
	getLinks: getLinks
	parseEmails: parseEmails
	bfs: crawlBfs
	sleep: sleep
