React = require 'react'
{ Link } = require 'react-router'

class Sidebar extends React.Component
	constructor: (props)->
		super props
		@state = routes: props.routes

	render: =>
		routes = @state.routes.map (route,i)=>
			<li className='nav-item' key={ i }>
				<Link to={ route.route }
					onClick={ => @selectRoute route.title }
					className={ 'nav-link'+(if route.selected then ' active' else '') } href='#'>
					<i className={ 'fa '+route.icon }> </i>
					&nbsp;{ route.title }
				</Link>
			</li>
		<nav className='col-sm-3 col-md-2 hidden-xs-down
			bg-faded sidebar bg-inverse navbar-inverse animated slideInLeft'>
			<ul className='nav nav-pills flex-column'>
				{ routes }
			</ul>
		</nav>

	selectRoute: (title)=>
		newRoutes = []
		for route in @state.routes
			if route.title is title then route.selected = true
			else route.selected = false
			newRoutes.push route
		@setState routes:newRoutes

module.exports = Sidebar
