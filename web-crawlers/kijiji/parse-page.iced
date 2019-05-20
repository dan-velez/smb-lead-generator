# Parse a Kijiji results page for leads

parseEmails = require '../crawlib/parse-emails.iced'

parsePage = ({ html, url, emitter })->

	emails = parseEmails html
	if emails
		console.log 'parsed emails', emails

module.exports = parsePage
