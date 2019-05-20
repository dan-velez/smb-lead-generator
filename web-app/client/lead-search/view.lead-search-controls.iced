React = require 'react'
ViewGeoSelect = require './view.geo-select.iced'
ViewItemSelect = require './view.item-select.iced'
ViewYellopagesControls = require './view.yellowpages-controls.iced'
ViewTruckingdbControls = require './view.truckingdb-controls.iced'
ViewSpokeControls = require './view.spoke-controls.iced'
ViewEzlocalControls = require './view.ezlocal-controls.iced'

class ViewLeadSearchControls	extends React.Component
	render: =>
		<div className='card animated fadeIn'>
			<div className='card-block'>
				<h6 className='card-title text-center'>Controls</h6><hr/>
				{ @sourceSelect() }
				<hr/>
				{
					if @props.searchSource is 'yellowpages.com'
						<ViewYellopagesControls
							setLocation={ @props.setLocation }
							setTerm={ @props.setTerm }
							/>

					else if @props.searchSource is 'ezlocal.com' or
					@props.searchSource is 'chamberofcommerce.com'
						<ViewEzlocalControls
							setTdbCity={ @props.setTdbCity }
							tdbState={ @props.tdbState }
							setTerm={ @props.setTerm }
							/>

					else if @props.searchSource is 'truckingdatabase.com' or
					@props.searchSource is 'all-contractors.com'
						<ViewTruckingdbControls
							setTdbCity={ @props.setTdbCity }
							tdbState={ @props.tdbState }
							/>

					else if (@props.searchSource is 'spoke.com') or
					@props.searchSource is 'brownbook.com'
						<ViewSpokeControls
							setTerm={ @props.setTerm } />

					else if @props.searchSource is 'google.com' or
					@props.searchSource is 'all-biz.com'
						<ViewYellopagesControls
							setLocation={ @props.setLocation }
							setTerm={ @props.setTerm }
							/>
					else <div></div>
				}
				<hr />
				{ @searchButton() }
			</div>
		</div>

	searchButton: =>
		<div>
			<button
				onClick={ @props.search }
				className='btn btn-outline-primary btn-block'
				type='submit'>
			Search</button>
			<button
				onClick={ @props.stopSearch }
				className='btn btn-outline-danger btn-block'
				type='button'>
			Stop Search</button>
		</div>

	sourceSelect: =>
		<div className='input-group'>
			<span className='input-group-addon fa fa-globe'></span>
			<select className='form-control'
				onChange={ @props.setSource }>
				<option selected disabled>Select a source</option>
				{
					@props.sources.map (source, i)->
						<option key={ i }>{source}</option>
				}
			</select>
		</div>

module.exports = ViewLeadSearchControls
