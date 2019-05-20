const React = require('react');

class ViewDatabaseFilters extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return (
      <div className='card'>
        <div className='card-block'>

          <h6 className='card-title'>Search Filters</h6>

          <div className='input-group'>
            <span className='input-group-addon fa fa-globe'>
            </span>
            <select className='form-control'>
              <option disabled selected>Lead source</option>
            </select>
          </div>

        </div>
      </div>
    );
  }
}

module.exports = ViewDatabaseFilters;