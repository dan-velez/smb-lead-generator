# Export a CSV file of leads.

exportCsv = (items)->
	# Parse the input into a csv string.
	csv = 'Company Name, Email, Phone, Mobile,' +
	' Other\n' +
	(items.map (lead)->
		# Join alternate phone numbers into one column.
		other = lead.other?.join ' '
		"\"#{lead.name or ''}\", " +
		"#{lead.email or ''}, " +
		"#{lead.phone or ''}, " +
		"#{lead.mobile or ''}, " +
		"#{other or ''}"
		# "\"#{lead.other?.join(', ') or ''}\" "
	).join '\n'

	csv = encodeURI csv

	# Download the document to users's pc.
	link = document.createElement 'a'
	link.setAttribute 'href', 'data:attachment/csv,' + csv
	link.setAttribute 'download', 'ebizfi-leadgen-search-results.csv'
	document.body.appendChild link
	link.click()

module.exports = exportCsv
