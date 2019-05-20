React = require 'react'

class ViewYellowpagesControls	extends React.Component
	render: =>
		<form className='animated fadeIn'>
			<input
				placeholder='Location'
				className='form-control'
				ref={ (input)=> @locationInput = input }
				onChange={ => @props.setLocation $(@locationInput).val() }
				/>
			<br/>
			<input
				placeholder='Search Term'
				className='form-control'
				ref={ (input)=> @termInput = input }
				onChange={ => @props.setTerm $(@termInput).val() }
				/>
		</form>

module.exports = ViewYellowpagesControls

###
ViewGeoSelect = require './view.geo-select.iced'
ViewItemSelect = require './view.item-select.iced'

<form className='animated fadeIn'>
	<br/>
	<ViewGeoSelect
		addLocation={ @props.addLocation }
		removeLocation={ @props.removeLocation }
		locations={ @props.locations }/>
	<br/>
	<ViewItemSelect
		title='Categories'
		add={ @props.addCategory }
		remove={ @props.removeCategory }
		selections={ @props.categories }/>
</form>
###
