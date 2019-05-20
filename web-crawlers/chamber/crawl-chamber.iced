# https://www.chamberofcommerce.com

bfsJS = require '../crawlib/bfs-js.iced'
{ EventEmitter } = require 'events'

# Parsing utils
parseEmails = require '../crawlib/parse-emails.iced'
parseNums = require '../crawlib/parse-phone-numbers.iced'
cheerio = require 'cheerio'

extractName = (path)->
	path = path.split('/')
	if path
		path[path.length-1]?.split('-')?.slice(1)?.join '-'
	else return ''

parseCity = (city)->
	city
	# city?.split(/\s+/g)?.join '%2C '

crawl = ({term, city, state})->
	city = city.toLowerCase()
	emitter = new EventEmitter
	control = running:true
	allEmails = {}
	visited = {}

	bfsJS
		root: 'https://www.chamberofcommerce.com'
		path: "/search/results?what=#{term}&where=#{parseCity city}%2C#{state}"
		control: control
		delay: 1000

		parse: ({ html, url })->
			emitter.emit 'log', log:"visiting #{url}"
			emails = parseEmails html
			nums = (parseNums(html) or [])
				.filter (n)-> n.startsWith '('
			if emails
				for email in emails
					if email and not allEmails[email]
						allEmails[email] = true
						$ = cheerio.load html
						name = $('title').text()
						name = (name.substring 0, name.lastIndexOf('in'))?.trim()
						emitter.emit 'lead', {
							name, email
							phone:nums[0]
							mobile:nums[1]
							other:nums.slice(2)
						}

		filter: (l)->
			name = extractName l
			if not visited[name]
				visited[name] = true
				pass = (l.includes("#{city.split(' ').join '-'}")) and
					(not l.includes('sign-in'))
				return pass
			else return false

	emitter.stop = -> control.running = false
	emitter

module.exports = crawl

#-- test program ----------------------------------------------#
###
crawler = crawl {term:'software', city:'miami', state:'FL'}
crawler.on 'log', (l)-> console.log log:l
crawler.on 'lead', (l)-> console.log lead:l
###
