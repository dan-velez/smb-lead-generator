React = require 'react'

class ViewGeoSelect extends React.Component
	componentDidMount: =>
		$(@input).geocomplete() # Set the autocompleter

	render: =>
		<div>
			{ @selectionInput() }
			<br/>
			{ @selectionArray() }
		</div>

	selectionInput: =>
		<div className='input-group'>
			<input ref={ (input)=> @input = input }
				className='form-control' placeholder='Locations' />
			<span className='input-group-btn'>
				<button className='btn btn-primary' type='button'
					onClick={ @addLocation }>
					<i className='fa fa-plus'></i>
				</button>
			</span>
		</div>

	selectionArray: =>
		<div style={{
				height: 'calc(30vh - 72px)'
				flex: 1
			}}>
			<div style={ {overflowY:'scroll', height:'100%'} }
				className=''>
				{
					@props.locations.map (item, i)=>
						<div key={ i }>
							<p className=''>
								<span >
									<button onClick={ => @props.removeLocation i }
									className='btn btn-default btn-sm'>X</button>
								</span>
								{ '  '+item }
							</p>
							<hr/>
						</div>
				}
			</div>
		</div>

	addLocation: =>
		@props.addLocation $(@input).val().split(', ')[0..1].join ', '
		$(@input).val ''

module.exports = ViewGeoSelect
