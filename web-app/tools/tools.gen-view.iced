# Generate an iced-backbone view.
# Usage: iced-backbone-gen-view [view-name] [subdir]

fs = require 'fs'
{ prompt } = require 'promptly'
path = require 'path'
mkdirp = require 'mkdirp'
out = console.log

args = process.argv.slice 2
view = args[0]
dir = args[1]

if not view or not dir
  out 'usage: iced-backbone-gen-view [view-name] [subdir]'
  process.exit()

genView = (name) -> """
	React = require 'react'

  class View#{name} extends React.Component
    render: =>
			<div>
			</div>

  module.exports = View#{name}
  """

viewstr = genView view

promptFileWrite = ->
  # transform name
  fname = 'view.' + (view.split(/(?=[A-Z])/g).map((s)-> s.toLowerCase()).join '-') + '.iced'
  out 'generating component: ', fname
  outdir = "#{path.resolve '.'}/client/#{dir}"
  await prompt "Confirm disk write to #{outdir}/#{fname}", defer err, resp
  throw err if err
  resp = resp.toLowerCase()
  if resp.startsWith 'n' then return process.exit()
  else if resp.startsWith 'y'
    out "Writing to #{outdir}/#{fname}..."
    await mkdirp outdir, defer err
    throw err if err
    await fs.writeFile "#{outdir}/#{fname}", viewstr, defer err
    throw err if err
    out 'Success!'

promptFileWrite()
