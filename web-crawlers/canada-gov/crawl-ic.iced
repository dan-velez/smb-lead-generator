bfsJS = require '../crawlib/bfs-js.iced'
parseEmails = require '../crawlib/parse-emails.iced'

bfsJS
	root: 'http://www.insiderpages.com'
	path: '/s/FL/Miami/Trucking'
	control: running:true

	delay: 1000

	parse: ({ html, url })->
		emails = parseEmails html
		if emails then console.log emails
		console.log '\n\n'
		console.log '>>> visit', url
		
	filter: (l)->
		# lx = l.split '/'
		# console.log 'first link elem', lx[0]
		# not l.startsWith('.') and not l.startsWith('#')
		parts = l.split('/')
		pass = (parts.indexOf('b') > -1) or (parts.indexOf('s') > -1)
		if pass then console.log 'filtering', l
		pass
