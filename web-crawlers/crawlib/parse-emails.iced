# Parse all the emails in an html document.

parseEmails = (html)->
	emails = html.match(
		/[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/ig)
	return null if not emails
	emails.map (e)-> e.toLowerCase()
	.filter (e, i)-> emails.lastIndexOf(e) is i

module.exports = parseEmails
