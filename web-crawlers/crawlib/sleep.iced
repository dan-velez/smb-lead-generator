# An implementation of a thread sleep.
# Usage: await sleep 1000, defer()

sleep = (ms, callb)->
	setTimeout callb, ms

module.exports = sleep