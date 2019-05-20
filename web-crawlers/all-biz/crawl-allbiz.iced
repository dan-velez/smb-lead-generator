# Crawl http://all-biz.com.
# input: STATE, TERM (e.g. "FL", "Trucking")


cheerio = require 'cheerio'
parseEmails = require '../crawlib/parse-emails.iced'
parsePhoneNumbers = require '../crawlib/parse-phone-numbers.iced'
bfs = require '../crawlib/bfs-js-http.iced'
{ EventEmitter } = require 'events'


parsePath = ({ state, term})->
	# Example: https://www.allbiz.com/search?ss=truck&ia=US_AL
	"/search?ss=#{term}&ia=US_#{state}"


parsePage = ({
	emitter 	# Output leads to this emitter.
	html		# The html content of the document.
	url			# Source of the document
	})->

	# Find name
	$ = cheerio.load html
	title = $('title').text()
	# console.log "Visiting page: [#{title}]"
	if title then name = title.split(/\-/)[0].trim()

	# Business contact
	bizname = $('body').find('div.container>div.block.detailed-block>p.detailed-header>b')
	if bizname.length > 0
		bizname = $(bizname[0]).text()
		if bizname.toLowerCase().includes("contact")
			bizname = ""

	# Find emails
	emails = parseEmails html

	# Find phone numbers
	nums = parsePhoneNumbers html
	if nums
		# Remove dups
		nums = nums.filter (n,i)-> nums.indexOf(n) == i
		nums = nums.filter (n)-> n.startsWith '('
	#	nums = nums.filter (n, i)-> nums.lastIndexOf(n) is i
	
	# Emit lead to socket
	if name and emails and emails.length > 0
		# Parse leads. Send a lead for each email.
		for email in emails
			emitter.emit 'lead', {
				name
				contact: bizname
				email
				phone: if nums then nums[0] else null
				mobile: if nums then nums[1] else null
				other: if nums then nums[2..nums.length-1] else null
			}


crawlAllbiz = ({ state, term })->
	url = parsePath { state, term }
	console.log 'url is', url

	# Use this emitter to broadcast leads found.
	emitter = new EventEmitter

	control =
		running: true

	bfs
		root: 'http://www.allbiz.com'
		path: parsePath { state, term }
		delay: 1000
		
		# Control the flow of the function with this variable.
		# Otherwise the function will crawl until its queue is empty.
		control: control

		parse: ({html, url})->
			# Retrieve leads from page using an external function.
			emitter.emit 'log', log:"visit #{url}"
			parsePage {emitter, html, url }

		filter: (l)->
			l.includes "business"
			# true

	emitter.stop = -> control.running = false
		
	emitter


module.exports = crawlAllbiz


#** test program ***********************************************
###
crawler = crawlAllbiz
	state: 'AL',
	term: 'Trucks'

crawler.on 'log', (log)-> console.log JSON.stringify({log:log}, null, 4)
crawler.on 'lead', (lead)-> console.log JSON.stringify({lead:lead}, null, 4)
###
# console.log parsePath {state:"NY", city:"New York"}