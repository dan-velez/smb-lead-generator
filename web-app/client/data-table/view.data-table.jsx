/* A customizable data table component for CRUD operations
 * on database records.
 */

const React = require('react');
const Pager = require('./view.pager.jsx');
const Thead = require('./view.thead.jsx');
const Tbody = require('./view.tbody.jsx');

const dataTable = ({ items, page, gotoPage,
                     pagerSize, columns, title })=> {

	/*
	const startIndex = (page - 1) * pageSize;
	const endIndex = startIndex + pageSize;
	const showItems = items.slice(startIndex, endIndex);
	*/

	return (
		<div className='card animated fadeIn'>
			<div className='card-block'>
				<indicator />
				<h6 className='card-title text-center'>
					{ title }
				</h6>
				<hr />

				<Pager 
					page={ page }
					gotoPage={ gotoPage }
					/>

				<table
					className='table table-hover table-bordered'
					style={ {width:'100%'} }>

					<Thead 
						columns={ columns }
						/>

					<Tbody 
						columns={ columns }
						items={ items }
						/>

				</table>
			</div>
		</div>
	);
};

module.exports = dataTable;
