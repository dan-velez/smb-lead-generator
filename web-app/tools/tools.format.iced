# Micellaneous text parsing routines

class AxisText
	wordCamelToDashed: (inword)->
		res = ''
		humps = inword.split /(?=[A-Z])/ # Split by the hump.
		for word,i in humps
			if i < humps.length-1
				res += (word[0].toLowerCase())+word.slice(1)+'-'
			else res += (word[0].toLowerCase())+word.slice(1)
		res

	formatMoneyInput: (e)=>
		if e.keyCode >= 48 and e.keyCode <= 57
			input = $(e.currentTarget).val().toString()
			$(e.currentTarget).val @formatMoney input

	formatMoney: (num)=>
		num = num.split('').reverse().join('')
		numMoney = ''
		for digit,i in num
			if i % 3 is 0 and i isnt 0 then numMoney+=','
			numMoney+=digit
		numMoney.split('').reverse().join('')

	formatMoneyInputs: =>
		$(@el).find("input[type='money']").each (i, elem)=>
			$(elem).val @formatMoney $(elem).val()

axisfs = require 'axis-fs'
exec = require('child_process').exec
fs = require 'fs'
path = require 'path'

class AxisRefactor

	fileNamesCamelToDashed: (icedFiles, write=false)=>
		# Convert camel case file names to their - - equivilants.
		# Dont exec unless write a script to replace in require statements.
		newFiles = []
		# Use linux mv command
		for file in icedFiles
			oldFname = file
			# newFname = oldFname.split(/[A-Z]/).join '-'
			newFname = ''
			paths = oldFname.split '/'
			fname = paths[paths.length-1]
			newFname = @wordCamelToDashed fname
			newFname = paths[0..paths.length-2].join('/')+"/"+newFname
			newFiles.push newFname
		if write then @mvArray icedFiles, newFiles

	# Possible method for axis-fs
	mvArray: (arr1, arr2)=>
		# Move files from arr1 to corresponding paths in arr2 by index.
		for i in [0..arr1.length-1]
			console.log "#{arr1[i]} ==> #{arr2[i]}"
			await exec "mv #{arr1[i]} #{arr2[i]}", defer err, stderr, stdout
			console.log err if err
			console.log stderr if stderr
			console.log stdout if stdout

	mapRequireString: (icedFiles, fn)->
		# Parse by line.
		# Print out new code for each file followed by a delimeter.
		axisText = new AxisText
		for file in icedFiles
			oldCode = fs.readFileSync(file).toString()
			codeLines = oldCode.split '\n'
			for line,i in codeLines
				if line and line.includes ' require '
					newLine = fn line
					# Splice the new line in
					codeLines.splice i, newLine
			# newCode = codeLines.join '\n'
			# if write # Write using fs.writeFileSync

camelToDot = ->
	out = console.log
	icedFiles = axisfs.dirSearch path.resolve('.'), '\.iced$'
	icedFiles = icedFiles.filter (pathname)->
		return if pathname.includes 'node_modules'
		filename = pathname.split('/').slice(-1)[0]
		if filename[0] is filename[0].toUpperCase()
			# construct new path
			humps = filename.split(/(?=[A-Z])/).map (w)-> w.toLowerCase()
			filename = humps.join '-'
			filename = filename.replace '\-', '.'
			base = pathname.split('/')
			base.pop()
			outpath = base.join('/') + '/' + filename
			cmd = "mv #{pathname} #{outpath}"
			out cmd
			await exec cmd, defer a, b, c
			out a, b, c

###
(new AxisRefactor).mapRequireString icedFiles, (requireString)->
	# splice the array if lines with the new one.
	lineWords = line.split /\s+/
	linePath = lineWords[lineWords.length-1]
	console.log linePath
	# axisText.wordCamelToDashed (path.basename(linePath).replace /\W/g, '')
###
