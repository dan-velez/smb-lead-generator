# Parse all phone numbers in an html document.

parsePhoneNumbers = (html)->
	html.match /\(?\s*(\d{3})\s*\)?\s*(\d{3})\s*\-?\s*(\d{4})/g

module.exports = parsePhoneNumbers