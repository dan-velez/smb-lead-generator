const React = require('react');

const pager = ({ gotoPage, page })=> {
	/* Need to pass num pages */
  const numPages = 10;

  let firstPage = page - 2;
  if(firstPage < 1) firstPage = 1;

  let lastPage = page+2;
  if(lastPage > numPages) lastPage = numPages;

  let buffer = []
  if(lastPage-page > 0)
    for(let i = firstPage; i < lastPage; i++)
      /* if there is a paging bug, add +1 to lastpage */
      buffer.push(i);

  return (
    <nav>
      <ul className="pagination">
        <li className="page-item">

          <a className="page-link"
            aria-label="Previous"
						onClick={ ()=> gotoPage(page-1) }>
            <span aria-hidden="true">&laquo;</span>
            <span className="sr-only">Previous</span>
          </a>

        </li>
        {
          buffer.map((n)=> (
            <li
              className={
									"page-item " + (n == page ? 'active' : '')
                }
                key={ n }>
							<a className="page-link"
								 onClick={ ()=> gotoPage(n) }>
                { n }
              </a>
            </li>
          ))
        }
        <li className="page-item">

          <a className="page-link" aria-label="Next"
						onClick={ ()=> gotoPage(page+1) }>
            <span aria-hidden="true">&raquo;</span>
            <span className="sr-only">Next</span>
          </a>

        </li>
      </ul>
    </nav>
  );
};

module.exports = pager;
