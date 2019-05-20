# Crawl http://ezlocal.com
#--------------------------------------------------------------#

bfsJS = require '../crawlib/bfs-js.iced'
{ EventEmitter } = require 'events'

# For parser.
cheerio = require 'cheerio'
parseEmails = require '../crawlib/parse-emails.iced'
parsePhones = require '../crawlib/parse-phone-numbers.iced'

crawlEzlocal = ({term, city, state})->
	emitter = new EventEmitter
	control = running:true
	allEmails ={}

	location = "#{city}, #{state}"

	bfsJS
		root: 'http://ezlocal.com'
		path: "/search/?q=#{term}&by=#{location}&z="
		# path: "/search/?q=#{term}&by=miami%2c+fl&z="
		control: control
		delay: 1700

		parse: ({ html, url })->
			emitter.emit 'log', log:"visiting #{url}"
			emails = parseEmails html
			nums = parsePhones(html)?.filter (n)-> n.startsWith '('
			$ = cheerio.load html
			name = $('title')?.text()
			if name
				name = name.substring(0, name.lastIndexOf('-'))?.trim()
			if emails
				for email in emails
					if not allEmails[email]
						emitter.emit 'lead', {name, email, phone:nums[0]}
						allEmails[email] = true
			
		filter: (l)->
			pass = (l.includes('business')) or
			(l.includes('search'))
			pass

	emitter.stop = -> control.running = false
	emitter

module.exports = crawlEzlocal
#-- test program ----------------------------------------------#
###
crawler = crawlEzlocal {term:'karate', city:'new york', state:'ny'}
crawler.on 'log', (l)-> console.log log:l
crawler.on 'lead', (l)-> console.log lead:l
###
