# An interactive prompt to generate iced-react components.
# Components can either be a route or a view,
# i.e. container or presentational.

{ prompt } = require 'promptly'
fs = require 'fs'
out = console.log
path = require 'path'

out "iced-react-compgen v - 0.0.0"

icedReactCompgen = ->
	out 'Component types'
	out '[ route ]	A container for a set of views'
	out '[ view ]	A presentational component'
	q = 'What type of component would you like to generate?'
	await prompt q, defer err, componentType
	q = 'What is then name of the component? (lower-dashed-case)'
	await prompt q, defer err, componentName
	q = 'Where would you like to store the component? (subdir in client/)'
	await prompt q, defer err, componentDir
	out 'Confirm write [y|n]', "#{path.resolve '.'}/client/#{componentDir}/#{componentName}"

genComponentName = (baseName, type)->

icedReactCompgen()
