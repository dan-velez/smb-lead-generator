/*
const move
  R: ()=> {},  
};

const moveLock = (dir, lock)=>
  lock.map((row, y)=>
    (row.map((block, x)=> lock[y-1][x] || '.' ))
    .join('')
  )

const secretArchivesLock = (lock, actions)=>
  actions.length == 0 ? lock
  : secretArchivesLock (
    moveLock(lock, actions[0]),
    actions.slice(1)
  )
*/
