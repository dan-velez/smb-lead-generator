# A paginated table to display the lead search results.

React = require 'react'

exportCsv = (items)->
	# Parse the input into a csv string.
	csv = 'Company Name, Email, Phone, Mobile,' +
	' Other, Contact\n' +
	(items.map (lead)->
		# Join alternate phone numbers into one column.
		other = lead.other?.join ' '
		"\"#{lead.name or ''}\", " +
		"#{lead.email or ''}, " +
		"#{lead.phone or ''}, " +
		"#{lead.mobile or ''}, " +
		"#{other or ''}," +
		"#{lead.contact or ''}"
		# "\"#{lead.other?.join(', ') or ''}\" "
	).join '\n'

	csv = encodeURI csv

	# Download the document to users's pc.
	link = document.createElement 'a'
	link.setAttribute 'href', 'data:attachment/csv,' + csv
	link.setAttribute 'download', 'ebizfi-leadgen-search-results.csv'
	document.body.appendChild link
	link.click()


class ViewLeadSearchResults extends React.Component
	render: =>
		startIndex = (@props.resultsPage - 1) * @props.pageSize
		endIndex = startIndex + @props.pageSize
		results = @props.results.slice startIndex, endIndex

		<div className='card animated fadeIn'>
			<div className='card-block'>
				{ @indicator() }
				<h6 className='card-title text-center'>
					Results
					<small className='text-muted'>total -
					{ @formatTotal @props.results.length }</small>
				</h6>
				<hr />
				{ @pager() }
				<table
					className='table table-hover table-bordered'
					style={ {width:'100%'} }>

					<thead>
						<tr>
							<th>Name</th>
							<th>Email</th>
							<th>Phone</th>
							<th>Mobile</th>
							<th>Other</th>
							<th>Contact</th>
						</tr>
					</thead>
					<tbody>
						{
							results.map (lead, i)->
								<tr key={ i }>
									{
										if lead.site
											<td>
												<a href={ lead.site } target='blank'>
													{ lead.name }
												</a>
											</td>
										else <td>{ lead.name }</td>
									}
									<td>{ (lead.email) or 'n/a' }</td>
									<td>{ (lead.phone) or 'n/a' }</td>
									<td>{ (lead.mobile) or 'n/a' }</td>
									<td>{ (lead.other?.join ', ') or 'n/a' }</td>
									<td>{ (lead.contact) or '' }</td>
								</tr>
						}
					</tbody>
				</table>
			</div>
		</div>

	pager: =>
		numPages = @lastPage()+1
		page = @props.resultsPage

		firstPage = page - 2
		if firstPage < 1 then firstPage = 1

		lastPage = page+2
		if lastPage > numPages then lastPage = numPages

		buffer = []
		if lastPage-page > 0
			for i in [firstPage..lastPage]
				buffer.push i

		<nav>
			<ul className="pagination">
				<li className="page-item">
					<a className="page-link"
						aria-label="Previous"
						onClick={ @prevPage }>
						<span aria-hidden="true">&laquo;</span>
						<span className="sr-only">Previous</span>
					</a>
				</li>
				{
					buffer.map (n)=>
						<li
							className={
									"page-item " + (if n is @props.resultsPage then 'active')
								}
								key={ n }>
							<a className="page-link" onClick={ => @props.gotoPage n }>
								{ n }
							</a>
						</li>
				}
				<li className="page-item">
					<a className="page-link" aria-label="Next" onClick={ @nextPage }>
						<span aria-hidden="true">&raquo;</span>
						<span className="sr-only">Next</span>
					</a>
				</li>
			</ul>
		</nav>

	lastPage: =>
		Math.floor @props.results.length / @props.pageSize

	nextPage: =>
		@props.gotoPage @props.resultsPage+1

	prevPage: =>
		@props.gotoPage @props.resultsPage-1

	indicator: =>
		if @props.searching
			<span className='fa fa-spinner fa-2x fa-spin'></span>
		else
			<div className='btn-group' role='group'>
				<button
					type='button'
					title='Export results to a CSV file'
					onClick={ @exportResults }
					className='btn btn-outline-primary'>
					<span className='fa fa-2x fa-cloud-download'></span>
				</button>
				<button
					type='button'
					title='Index the results to database for quick access'
					onClick={ => }
					className='btn btn-outline-primary'>
					<span className='fa fa-2x fa-database'></span>
				</button>
			</div>

	exportResults: =>
		exportCsv @props.results

	formatTotal: (total)=>
		total = total.toString().split('').reverse().join ''
		res = ''
		for c,i in total
			if i > 0 and i % 3 == 0 then res+=','
			res += c
		res.split('').reverse().join('')

module.exports = ViewLeadSearchResults
