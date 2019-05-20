# Helper method to concatenate the root and path

makeUrl = (root, node)->
	if node.startsWith 'http' then return node
	if node.startsWith '/' then node = node.slice 1
	if root.endsWith '/'
		root = root.substring 0, root.length-2
	"#{root}/#{node}"

module.exports = makeUrl