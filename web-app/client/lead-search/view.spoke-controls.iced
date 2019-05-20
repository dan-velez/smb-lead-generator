React = require 'react'

class ViewSpokeControls	extends React.Component
	render: =>
		<form className='animated fadeIn'>
			<input
				placeholder='term'
				className='form-control'
				ref={ (input)=> @termInput = input }
				onChange={ => @props.setTerm $(@termInput).val() }
				/>
		</form>

module.exports = ViewSpokeControls
