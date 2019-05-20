React = require 'react'

class ViewItemSelect extends React.Component
	componentDidMount: =>

	render: =>
		<div>
			{ @selectionInput() }
			<br/>
			{ @selectionArray() }
		</div>

	selectionInput: =>
		<div className='input-group'>
			<input ref={ (input)=> @input = input }
				className='form-control' placeholder={ @props.title } />
			<span className='input-group-btn'>
				<button className='btn btn-primary' type='button'
					onClick={ @add }>
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
					@props.selections.map (item, i)=>
						<div key={ i }>
							<p className=''>
								<span >
									<button onClick={ => @props.remove i }
									className='btn btn-default btn-sm'>X</button>
								</span>
								{ '  '+item }
							</p>
							<hr/>
						</div>
				}
			</div>
		</div>

	add: =>
		@props.add $(@input).val()
		$(@input).val ''

module.exports = ViewItemSelect
