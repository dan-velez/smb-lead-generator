const React = require('react');

const thead = ({ columns })=> {
	return (
		<thead>
			<tr>
				{
					columns.map((c,i)=> {
						return (
							<td key={ i }>{ c }</td>
						);
					})
				}
			</tr>
		</thead>
	);
};

module.exports = thead;
