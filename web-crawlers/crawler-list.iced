# A list of available crawler for the service to use.

# Import available crawling functions.
crawlTruckingdb = require './truckingdb/crawl-truckingdb.iced'
crawlYellowpages = require './yellowpages/crawl-yellowpages.iced'
crawlGoogle = require './google/crawl-google.iced'
crawlSpoke = require './spoke/crawl-spoke.iced'
crawlBrownbook = require './brownbook/crawl-brownbook.iced'
crawlEzlocal = require './ezlocal/crawl-ezlocal.iced'
crawlChamber = require './chamber/crawl-chamber.iced'
crawlAllContractors = require './all-contractors/crawl-allcontractors.iced'
crawlAllBiz = require './all-biz/crawl-allbiz.iced'

crawlerList =
	'truckingdatabase.com': crawlTruckingdb

	'yellowpages.com': crawlYellowpages

	'spoke.com': crawlSpoke

	'google.com': crawlGoogle

	'brownbook.com': crawlBrownbook

	'ezlocal.com': crawlEzlocal

	'chamberofcommerce.com': crawlChamber

	'all-contractors.com': crawlAllContractors

	'all-biz.com': crawlAllBiz

module.exports = crawlerList