# Crawl http://all-contractors.com.
# input: STATE, CITY (e.g. "NY", "New York")


cheerio = require 'cheerio'
parseEmails = require '../crawlib/parse-emails.iced'
parsePhoneNumbers = require '../crawlib/parse-phone-numbers.iced'
bfs = require '../crawlib/bfs-js-http.iced'
{ EventEmitter } = require 'events'


parsePath = ({ state, city })->
	# Example: http://www.all-contractors.com/contractors-and-builders-in-New+York_NY
	# console.log "Input to parsePath: [#{state}] [#{city}]"
	"/contractors-and-builders-in-" + city.split(/\s+/).join("+") + "_#{state}"


parsePage = ({
	emitter 	# Output leads to this emitter.
	html		# The html content of the document.
	url			# Source of the document
	})->

	# Find name
	$ = cheerio.load html
	title = $('title').text()
	# console.log "Visiting page: [#{title}]"
	if title then name = title.split(/,\s+\-/)[0]

	# Find emails
	emails = parseEmails html

	# Find phone numbers
	nums = parsePhoneNumbers html
	if nums
		nums = nums.filter (n,i)-> nums.indexOf(n) == i
	#	nums = nums.filter (n)-> n.startsWith '('
	#	nums = nums.filter (n, i)-> nums.lastIndexOf(n) is i
	
	# Emit lead to socket
	if name and emails and emails.length > 0
		# Parse leads. Send a lead for each email.
		for email in emails
			emitter.emit 'lead', {
				name
				email
				phone: if nums then nums[0] else null
				mobile: if nums then nums[1] else null
				other: if nums then nums[2..nums.length-1] else null
			}


crawlAllContractors = ({ state, city })->
	url = parsePath { state, city }
	console.log 'url is', url

	# Use this emitter to broadcast leads found.
	emitter = new EventEmitter

	control =
		running: true

	bfs
		root: 'http://www.all-contractors.com'
		path: parsePath { state, city }
		delay: 1000
		
		# Control the flow of the function with this variable.
		# Otherwise the function will crawl until its queue is empty.
		control: control

		parse: ({html, url})->
			# Retrieve leads from page using an external function.
			emitter.emit 'log', log:"visit #{url}"
			parsePage {emitter, html, url }

		filter: (l)->
			# l.includes city.split(/\s+/).join("+") + "_#{state}"
			true

	emitter.stop = -> control.running = false
		
	emitter


module.exports = crawlAllContractors


#** test program ***********************************************
###
crawler = crawlAllContractors
	state: 'NY'
	city: 'New York'
crawler.on 'log', (log)-> console.log JSON.stringify({log:log}, null, 4)
crawler.on 'lead', (lead)-> console.log JSON.stringify({lead:lead}, null, 4)
###
# console.log parsePath {state:"NY", city:"New York"}