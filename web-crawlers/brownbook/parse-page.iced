parseEmails = require '../crawlib/parse-emails.iced'
cheerio = require 'cheerio'

visited = {}

parsePage = ({ emitter, html, url, node })->
		leads = []
		# Use cheerio to parse DOM directly (runs faster).
		$ = cheerio.load html

		$('.h-card').each (i,e)->
			lead = $(e).find('.business_sub_head').text()
			name = lead?.trim()?.split('\n')[2]?.trim()
			if name and not visited[name]

				email = $(e).find('.p-email').text()
				phone = $(e).find('.p-tel').text()
				mobile = $(e).find('.p-tel-mobile').text()

				if email
					visited[name] = true
					leads.push { name, email, phone, mobile }

		for lead in leads
			emitter.emit 'lead', lead

extractName = (path)->
	path = path?.split('/')[1]
	path

module.exports = parsePage
