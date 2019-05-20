/* CRUD and filter operations on leads database collection */

const React = require('react');
const ViewDatabaseFilters = require('./view.database-filters.jsx');
const ViewDataTable = require('../data-table/view.data-table.jsx');
const MongoCrest = require('mongo-crest-client');

class RouteDatabase extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
			title: "Leads Database", 
			leads: [],
			columns: [
				"Name",
				"Email",
				"Phone",
				"Location"
			],
			page: 1,
			pageSize: 10
    };

		/* Initialize REST API client */
		this.mongocrest = new MongoCrest(
			"http://mongo-crest-server.herokuapp.com/api"
		);

		/* Bind actions */
		this.gotoPage = this.gotoPage.bind(this);
		this.fetchLeads = this.fetchLeads.bind(this);

		/* Initiate state tree */
		this.fetchLeads();
  }

	fetchLeads() {
		/* Fetch the leads with the current filters and page */
		this.mongocrest.read(
			'contacts', 
			{
				page: this.state.page
			},
			(leads)=> {
				this.setState({leads:leads});
			}
		);
	}

  render() {
    return (
      <div className='row animated fadeIn'>
        <div className='col-md-8'>

          <ViewDataTable
						page={ this.state.page }
						title={ this.state.title }
						pageSize={ this.state.pageSize }
            items={ this.state.leads }
						columns={ this.state.columns }
						gotoPage={ this.gotoPage }
						/>

				</div>
        <div className='col-md-4'>

          <ViewDatabaseFilters
          />

        </div>
      </div>
    );
  }

	/* Actions */

	gotoPage(n) {
		/* Increase the page and fetch the leads from that page */
		if(n < 1) return;
		this.setState({page:n}, this.fetchLeads);
	}
}

module.exports = RouteDatabase;
