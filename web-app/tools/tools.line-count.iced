# LOC Counter. Run this file to output the number of lines in 
# each file, followed by the total lines of iced code.

out = console.log
fs = require 'fs'

isDir = (fname)->
  fs.statSync(fname).isDirectory()

class LinesCounter
	lines: 0

	numLinesInFile: (path)=>
		data = fs.readFileSync(path).toString()
		data.split('\n').length

	numLinesInDir: (root)=>
		files = fs.readdirSync root
		for file in files
			if isDir("#{root}/#{file}")
			then @numLinesInDir "#{root}/#{file}"
			else if file.endsWith('.iced')
				numLines = @numLinesInFile "#{root}/#{file}"
				out "-------------------"
				out "#{file} = #{numLines}"
				@lines += numLines
				#out @lines

f = new LinesCounter
f.numLinesInDir '.'
out f.lines
