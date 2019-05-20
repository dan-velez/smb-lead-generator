# Extract a lower dashed case name from url for yellowpages.com

extractName = (str)->
	name = str.substring 0, str.lastIndexOf '-'
	if name.match /\d{5,}/g
		return extractName name
	name

module.exports = extractName
