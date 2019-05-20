React = require 'react'
ViewLeadSearchControls = require './view.lead-search-controls.iced'
ViewLeadSearchResults = require './view.lead-search-results.iced'
ViewLeadSearchLogs = require './view.lead-search-logs.iced'
parseIncomingLead = require './parse-incoming-lead.iced'
io = require 'socket.io-client'
ping = require './ping-server.iced'

class RouteLeadSearch extends React.Component
	componentWillUnmount: =>
		@stopSearch()

	constructor: (props)->
		super props
		url = 'https://ebizfi-crawlerserver.herokuapp.com'

		# Set the crawlers data structure.
		@setCrawlers()

		@crawler = io url

		ping @crawler # Keep Alive.

		@crawler.on 'connect', =>
			out 'crawler connected to server', new Date
			@crawlerLog
				log: "connected to crawler @ #{url}"
				color:'green'

		@crawler.on 'disconnect', =>
			@crawlerLog {log: "connection closed", color:'red'}

		@crawler.on 'log', @crawlerLog
		@crawler.on 'lead', @crawlerLead

		@state =
			searching: false
			searchSource: ''
			keywords: []
			# For array data
			locations: []
			categories: []
			# For single term searches
			term: ''
			location: ''
			# For truckingdb
			tdb_state: ''
			tdb_city: ''
			# Results
			results: []
			resultsPage: 1
			pageSize: 10
			logs: []
			sources: [ # Available sources for searching.
				'yellowpages.com'
				'truckingdatabase.com'
				'spoke.com'
				'google.com'
				'brownbook.com'
				'ezlocal.com'
				'chamberofcommerce.com',
				'all-contractors.com',
				'all-biz.com'
			]

	# Decide which controls to render based on @state.searchSource
  # ------------------------------------------------------------ #

	render: =>
		<div>
			<div className='row'>
				<div className='col-md-4'>

					<ViewLeadSearchControls
						search={ @search }
						setSource={ @setSource }
						setTerm={ @setTerm }
						setLocation={ @setLocation }
						setTdbCity={ @setTdbCity }
						tdbState={ @tdbState }
						stopSearch={ @stopSearch }
						addLocation={ @addLocation }
						removeLocation={ @removeLocation }
						addCategory={ @addCategory }
						removeCategory={ @removeCategory }
						locations={ @state.locations }
						categories={ @state.categories }
						keywords={ @state.keywords }
						searchSource={ @state.searchSource }
						sources={ @state.sources } />

				</div>
				<div className='col-md-8'>

					<ViewLeadSearchLogs
						logs={ @state.logs } />

				</div>
			</div>
			<div className='row'>
				<div className='col-md-12'>

					<ViewLeadSearchResults
						gotoPage={ @gotoPage }
						pageSize={ @state.pageSize }
						pagerSize=5
						searching={ @state.searching }
						results={ @state.results }
						resultsPage={ @state.resultsPage } />

				</div>
			</div>
			<hr />
		</div>
  # ------------------------------------------------------------ #

	setCrawlers: =>
		@crawlers =
			'yellowpages.com':
				validate: @validateSingleTerms
				packet: =>
					location: @state.location
					term: @state.term

			'google.com':
				validate: @validateSingleTerms
				packet: =>
					location: @state.location
					term: @state.term

			'spoke.com':
				validate: -> true
				packet: =>
					term: @state.term

			'brownbook.com':
				validate: -> true
				packet: =>
					term: @state.term

			'ezlocal.com':
				validate: @validateTruckingdb
				packet: =>
					term: @state.term
					state: @state.tdb_state
					city: @state.tdb_city

			'chamberofcommerce.com':
				validate: @validateTruckingdb
				packet: =>
					term: @state.term
					state: @state.tdb_state
					city: @state.tdb_city

			'truckingdatabase.com':
				validate: @validateTruckingdb
				packet: =>
					state: @state.tdb_state
					city: @state.tdb_city

			'all-contractors.com':
				validate: @validateTruckingdb
				packet: =>
					state: @state.tdb_state
					city: @state.tdb_city

			'all-biz.com':
				validate: @validateAllBiz
				packet: =>
					state: @state.location
					term: @state.term

	search: (e)=>
		e.preventDefault()
		# Current source user is searching.
		source = @state.searchSource

		out 'source is: ', source
		out 'crawler', @crawlers[source]

		# Validate input #
		if @state.searching
			return toastr.error 'Search in progress'
		if not @state.searchSource or not @crawlers[source]
			return toastr.error 'Invalid search source'
		out 'validating...'
		return if not @crawlers[source].validate()
		out 'validated!'

		# Construct and send packet
		packet = Object.assign {source:@state.searchSource}
		, @crawlers[source].packet()
		out ">>> Sending packet", packet
		@crawler.emit 'search', packet

		# Set search state to true
		@setState searching:true
		toastr.success 'Search started. Check the logs for details.'

	validateSingleTerms: =>
		true

	validateAllBiz: =>
		valid = true
		if not @state.location or @state.location.length isnt 2
			toastr.error 'Invalid state. State must be a 2-letter '
			+ 'code e.g. FL, CA, TX'
			valid = false
		if not @state.term
			toastr.error 'Invalid term'
			valid = false		
		valid

	validateTruckingdb: =>
		out 'validating tdb variables...'
		valid = true
		if not @state.tdb_state or @state.tdb_state.length isnt 2
			toastr.error 'Invalid state. State must be a 2-letter '
			+ 'code e.g. FL, CA, TX'
			valid = false
		if not @state.tdb_city
			toastr.error 'Invalid city'
			valid = false
		valid

	validateYellowpages: =>
		valid = true
		if @state.locations.length is 0
			toastr.error 'Invalid locations'
			valid = false
		if @state.categories.length is 0
			toastr.error 'Invalid categories'
			valid = false
		valid

	crawlerLead: (lead)=>
		lead = parseIncomingLead lead
		@crawlerLog
				log: "lead found #{lead.name}"
				color: 'green'
		console.log lead
		leads = @state.results
		leads.push lead
		@setState results:leads

	crawlerLog: (log)=>
		if log.error
			@setState searching:false
			toastr.error log.error
		logs = @state.logs
		logs.push log
		@setState logs:logs

	stopSearch: =>
		# if not @state.searching
		#	return toastr.error 'Search isnt running'
		# toastr.warning 'Stopping crawler...'
		@setState searching:false
		@crawler.emit 'stop'

	gotoPage: (n)=>
		if n < 1 or n > Math.ceil @state.results.length / @state.pageSize
			return
		@setState resultsPage:n

	setSource: (e)=>
		@setState searchSource:e.target.value

	# Single term searches
	
	setLocation: (location)=>
		@setState location:location
	
	setTerm: (term)=>
		@setState term:term

	addLocation: (location)=>
		locations = @state.locations
		if not location then return toastr.error 'Invalid location'
		locations.push location
		@setState locations:locations

	removeLocation: (index)=>
		newLocs = @state.locations
		newLocs.splice index, 1
		@setState locations:newLocs

	addCategory: (item)=>
		list = @state.categories
		if not item then return toastr.error 'Invalid category'
		list.push item
		@setState categories:list

	removeCategory: (index)=>
		newLocs = @state.categories
		newLocs.splice index, 1
		@setState categories:newLocs

	# Truckingdb input
	
	setTdbCity: (city)=>
		@setState tdb_city:city

	tdbState: (str)=>
		@setState tdb_state:str

module.exports = RouteLeadSearch
