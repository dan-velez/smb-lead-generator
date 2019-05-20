React = require 'react'

class Navbar extends React.Component
	render: =>
		<nav className="navbar navbar-toggleable-md
		                navbar-inverse fixed-top bg-inverse animated fadeIn">
			<button
				aria-controls="navbarNavDropdown"
				aria-expanded="false"
				aria-label="Toggle navigation"
				className="navbar-toggler navbar-toggler-right hidden-lg-up"
				data-target="#navbarNavDropdown"
				data-toggle="collapse"
				type="button"
			>
				<span className="navbar-toggler-icon" />
			</button>
			<p className="navbar-brand" href="#">
				<img alt="" height="30" src="/img/logo-big.png" width="30" />
				Lead Generation
			</p>
			<div className="collapse navbar-collapse" id="navbarNavDropdown">

			</div>
		</nav>

module.exports = Navbar

###
				<ul className="navbar-nav ml-auto">
					<div className="nav-item dropdown">
						<a
							aria-expanded="false"
							aria-haspopup="true"
							className="nav-link dropdown-toggle"
							data-toggle="dropdown"
							id="navbarDropdownMenuLink"
						>
							<span className="fa fa-2x fa-cog" />
						</a>
						<div aria-labelledby="navbarDropdownMenuLink" className="dropdown-menu">
							<a className="dropdown-item">Invert theme</a>
							<a className="dropdown-item">Logout</a>
						</div>
					</div>
				</ul>
				<form className="form-inline mt-2 mt-md-0">
					<input className="form-control mr-sm-2" placeholder="Search" type="text" />
					<button className="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
				</form>
###