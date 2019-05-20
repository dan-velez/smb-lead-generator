React = require 'react'

class ViewTruckingdbControls	extends React.Component
	render: =>
		<div className='animated fadeIn'>
			{ @stateInput() }
			<br/>
			{ @cityInput() }
		</div>

	stateInput: =>
		<input
			className='form-control'
			placeholder='State'
			ref={ (input)=> @tdb_state = input }
			onChange={ => @props.tdbState $(@tdb_state).val() }
			/>

	cityInput: =>
		<input
			className='form-control'
			placeholder='City'
			ref={ (input)=> @tdb_city = input }
			onChange={ => @props.setTdbCity $(@tdb_city).val() }
			/>

module.exports = ViewTruckingdbControls
