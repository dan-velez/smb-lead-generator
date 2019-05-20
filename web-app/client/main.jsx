const React = require('react');
const ReactDOM = require('react-dom');
const { Router, Route, hashHistory } = require('react-router');

/* App boilerplate */
const ViewSidebar = require('./sidebar/view.sidebar.iced');
const ViewNavbar = require('./navbar/view.navbar.iced');


/* Require Routes */
const RouteLeadSearch = require(
	'./lead-search/route.lead-search.iced');
const RouteDatabase = require('./database/route.database.jsx');

/* App routes struct */
const routes =  [
	{
		title: 'Crawler',
		icon: 'fa-bug',
		selected: false,
		route: 'crawler',
	},

	{
		title: 'Database',
		icon: 'fa-database',
		selected: true,
		route: 'database'
	}
];

const App = (props)=> {
	const selectedRoute =
		(routes.filter(r => r.selected))[0].title;

	return (
    <div>
      <ViewNavbar />
      <div className='container-fluid'>
        <div className='row'>
          <ViewSidebar routes={ routes }/>
          <main
						style={{
						backgroundColor:'white',
							height: "100%"
						}}
						className='col-sm-9 offset-sm-3 col-md-10 offset-md-2 pt-3'>

            <ol className='breadcrumb animated slideInDown'>
              <li className='breadcrumb-item active'>
                { selectedRoute }
              </li>
            </ol>

            { props.children }
          </main>
        </div>
      </div>
    </div>
	);
};

$(()=> {
	/* Set toastr options */
  toastr.options = {
		showMethod: 'slideDown',
    timeOut: 1500
	};

  ReactDOM.render((
    <Router history={ hashHistory }>
      <Route path='/' component={ App }>
        <Route path='/crawler' component={ RouteLeadSearch } />
        <Route path='/database' component={ RouteDatabase } />
      </Route>
    </Router>
  ), document.getElementById('root'));

	/* Navigate to index route */
  hashHistory.push('/database');
});
