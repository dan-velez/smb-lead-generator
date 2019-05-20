## http://truckingdatabase.com/ lead parser ####################

# Parser for a truckingdatabase html document. 
# Search the documents for leads.

# HTML parser.
cheerio = require 'cheerio'
parseEmails = require '../crawlib/parse-emails.iced'
parsePhoneNumbers = require '../crawlib/parse-phone-numbers.iced'

parsePage = ({
	emitter # Output leads to this emitter.
	html		# The html content of the document.
	url			# Source of the document
	})->

	# Find name
	$ = cheerio.load html
	title = $('title').text()
	if title then name = title.substring 0, title.lastIndexOf ','

	# Find emails
	emails = parseEmails html

	# Find phone numbers
	nums = parsePhoneNumbers html
	if nums
		nums = nums.filter (n)-> n.startsWith '('
		nums = nums.filter (n, i)-> nums.lastIndexOf(n) is i
	
	# Emit lead to socket
	if name and emails and emails.length > 0
		# Parse leads. Send a lead for each email.
		for email in emails
			emitter.emit 'lead', {
				name
				email
				phone: nums[0]
				mobile: nums[1]
				other: nums[2..nums.length-1]
			}

module.exports = parsePage
