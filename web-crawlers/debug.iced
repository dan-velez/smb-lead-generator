# Periodically log heap snapshots to the console.

snapshot = ->
	console.log ((process.memoryUsage().heapUsed / 1024) / 1024) + 'MB'
	setTimeout snapshot, 2000

snapshot()
