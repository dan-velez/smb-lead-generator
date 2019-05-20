# Use the crawlers to index the results into a database.
# Do not store duplicates from the same source.
#
# This server should be connected to the main database server.
# There should also be a users server.
# The scraper should be user to generate NEW leads.
# Once they are scraped, they are stored into a database for fast access.
# Leads from all sites should be of the same model.
# Therefore the interface needs revision.
#
#	Main functions ->
#		crud an existing database of leads.
# 	using a webscraper to generate more leads for this database.
# 	exporting leads to a csv format.
#
# Sub functions ->
# 	This server allows a user to use the scraping service from a web panel.
# 	The scraper then saves its outputs to the main database?, or prompts user
# 	to save. The scraper does not include duplicate results already in the database.
