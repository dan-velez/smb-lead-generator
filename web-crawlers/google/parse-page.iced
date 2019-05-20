# Parse a google results page for leads.

cheerio = require 'cheerio'
parseEmails = require '../crawlib/parse-emails.iced'
parsePhoneNumbers = require '../crawlib/parse-phone-numbers.iced'

parseGooglePage = ({ html, url, emitter })->
	emails = parseEmails html
	if emails
		for email in emails
			emitter.emit 'lead', { email }

module.exports = parseGooglePage
