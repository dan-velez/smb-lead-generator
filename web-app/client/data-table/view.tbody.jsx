const React = require('react');

const tbody = ({ items, columns })=> {
	return (
		<tbody>
			{
				items.map((lead, i)=> {
					return (
						<tr key={ i }>
							{
								lead.site ? 
									<th>
										<a href={ lead.site } target='blank'>
											{ lead.name }
										</a>
									</th>
								: <th>{ lead.name }</th>
							}
							<th>{ (lead.email)  || 'n/a' }</th>
							<th>{ (lead.phone)  || 'n/a' }</th>
							<th>{ (lead.mobile) || 'n/a' }</th>
						</tr>
					);
				})
			}
		</tbody>
	);
};

module.exports = tbody;
