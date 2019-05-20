# Parse a yellowpages document for leads

cheerio = require 'cheerio'
parseEmails = require '../crawlib/parse-emails.iced'
parsePhoneNumbers = require '../crawlib/parse-phone-numbers.iced'

#--------------------------------------------------------------#
# Extract parts from the URL ----------------------------------#

dashedToSpaced = (str)->
	# Convert a word in lower-dashed-case to Upper Spaced Case.
	words = str.split '-'
	words.map((word, i)->
		word = word[0].toUpperCase() + word.slice(1)
		if i is words.length - 1 then word = word.toUpperCase()
		if i is words.length - 2 then word+','
		else word
	).join ' '

extractLocation = (str)->
	# Extract location from a yellowpages url.
	str = dashedToSpaced str.split('/')[3]

extractName = (str, url)->
	# Name is before location. Extract location first.
	location = extractLocation url
	str.substring(0, str.search location).trim()

# test --------------------------------------------------------#

###
url = 'http://yellowpages.com/new-york-ny/mip/'+
	'man-machine-18182468?lid=18182468'
title = 'Man & Machine New York, NY 10001 - YP.com'
console.log 'extract name', extractName title, url
###

#--------------------------------------------------------------#

parseYellowpagesHtml = ({ html, emitter, url })->
	# Don't parse non company pages.
	return if not url.includes 'mip'

	# Get page title, i.e. lead name
	$ = cheerio.load html
	title = $('title').text()
	if title
		name = extractName title, url

	# Get emails
	emails = parseEmails html
	if emails
		emails = emails.filter (e)-> not e.includes 'yp-logo'

	# Get phone numbers
	nums = parsePhoneNumbers html
	if nums
		nums = nums.filter (n)-> n.startsWith '('
		nums = nums.filter (n, i)-> nums.lastIndexOf(n) is i

	# Parse and emit leads
	if emails and emails.length > 0
		for email in emails
			emitter.emit 'lead', {
				name
				email
				phone: nums[0]
				mobile: nums[1]
				other: nums[2..nums.length-1]
			}

module.exports = parseYellowpagesHtml
