const React = require('react');
// const exportCsv = require('./../lead-search/export-csv.iced');

const controls = ({ })=> (
	if(searching)
		<span className='fa fa-spinner fa-2x fa-spin'></span>
	else
		<div className='btn-group' role='group'>
			<button
				type='button'
				title='Export results to a CSV file'
				onClick={ exportCsv }
				className='btn btn-outline-primary'>
				<span className='fa fa-2x fa-cloud-download'></span>
			</button>
			<button
				type='button'
				title='Index the results to database for quick access'
				onClick={ ()=>{} }
				className='btn btn-outline-primary'>
				<span className='fa fa-2x fa-database'></span>
			</button>
		</div>
);

const exportItems = ()=> {

};

module.exports = controls;
