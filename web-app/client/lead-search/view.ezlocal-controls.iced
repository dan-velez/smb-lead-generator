React = require 'react'

class ViewEzlocalControls	extends React.Component
	render: =>
		<div className='animated fadeIn'>
			{ @termInput() }
			<br/>
			{ @stateInput() }
			<br/>
			{ @cityInput() }
		</div>

	termInput: =>
		<input
			className='form-control'
			placeholder='Term'
			ref={ (input)=> @termRef = input }
			onChange={ => @props.setTerm $(@termRef).val() }
			/>

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

module.exports = ViewEzlocalControls
