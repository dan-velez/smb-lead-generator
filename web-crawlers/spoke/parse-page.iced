# Parse an html document from http://spoke.com for leads.

parseEmails = require '../crawlib/parse-emails.iced'
parseNums = require '../crawlib/parse-phone-numbers.iced'
cheerio = require 'cheerio'

parsePage = ({ html, url, emitter, visited })->
	emitter.emit 'log', log: "visiting #{url}"

	# Parse emails
	emails = parseEmails html
	$ = cheerio.load html

	# Get title.
	name = $('title').text()

	# Parse location
	location = (name.slice (name.indexOf ',')+2 )
	if location and location.length > 1
		location = location.trim()
		if location
			location = location.substring 0
			, location.indexOf('|')# ?.trim()
		if location
			location = location.trim().split ', '
			city = location[0]
			state = location[1]

	# Parse name.
	name = name.substring 0, name.indexOf ','

	# Parse phone number
	nums = parseNums html
	if nums
		nums = nums.filter (n)-> n.startsWith '('
		nums = nums.filter (n,i)-> nums.lastIndexOf(n) is i
	else nums = []

	if emails then for email in emails
		if not visited[email] and not city.includes 'Results'
			visited[email] = true
			emitter.emit 'lead', {
				name
				email
				state
				city
				phone: nums[0]
				mobile: nums[1]
				other: nums.slice 2
			}

module.exports = parsePage
