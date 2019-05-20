React = require 'react'

class RouteLeadSearch extends React.Component
	componentDidUpdate: =>
		@scroller?.scrollTop = @scroller.scrollHeight

	render: =>
		<div className='card'>
			<div className='card-block'>
				<h6 className='card-title text-center'>Logs</h6><hr/>
				<div ref={ (div)=> @scroller = div }
					style={{
						overflowY:'scroll'
						maxHeight:'300px'
						height:'300px'
					}}>
					{
						@props.logs.map (log, i)=>
							<p style={ {color:log.color or 'blue'} }
								key={ i }>
								{ "> #{@linkify (log.log or log.error)}" }
							</p>
					}
				</div>
			</div>
		</div>

	linkify: (str)=>
		str

module.exports = RouteLeadSearch
