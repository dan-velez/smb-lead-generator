# This class contains methods for refactoring an iced project.

fs = require 'fs'

class Refactorer
	isDir: (path)->
		fs.lstatSync(path).isDirectory()

	dirSearch: (dir, rgx)->
			# Search a directory for filenames that match rgx.
			# Return an array of paths.
			if dir.endsWith '/'
				dir = dir.substring 0, dir.length-1
			res = []
			files = fs.readdirSync dir
			for file in files
				if @isDir "#{dir}/#{file}"
					res = res.concat @dirSearch "#{dir}/#{file}", rgx
				else
					if "#{dir}/#{file}".match(rgx)
						res.push "#{dir}/#{file}"
			res

	replaceWord: ({dir, inWord, outWord})=>
		# Search all files in a directory for input word and
		# replace it with output word. Searches the entire contents
		# of each file.
		files = @dirSearch dir, ".iced"
		for file in files
			continue if not file.endsWith '.iced'
			console.log "replacing #{inWord} to #{outWord} in #{file}"
			@replaceWordInFile inWord, outWord, file

	replaceWordInFile: (inputWord, outWord, file)=>
		# Replace contents of all matched words in a file.
		# This method writes to disk.
		await fs.readFile file, defer err, data
		return console.error err if err
		data = data.toString().replace new RegExp(inputWord, "g"), outWord
		await fs.writeFile file, data, defer err, data
		return console.error err if err

	dirIcedFiles: (dir)=>
		# Search a directory for iced files.

	mapViews: (fn)=>
		# Run a function for each view component, with the filename as the arg.
		for file in @appFiles()
			if file.includes('/views/') and not file.includes 'template'
				fn(file)
			
	mapFiles: (dir, fn)=>
		# Run a function for each iced file in a directory.
		fn(file) for file in @dirSearch dir, '.iced'

	mapTemplates: (fn)=>
		# Run a function for each template component in a directory.
		# Need javascript parser.
		templates = @dirSearch "#{appRoot()}/views", "_template"
		fn(t) for t in templates

	appendToFileNames: (files, suffix)=>
		# Append a suffix to an array of files.
		r.mapViews (file)=>
			# can use `exec 'mv'` instead
			oldFile = file
			nspaces = file.split '/'
			newFile = "#{suffix}#{nspaces[nspaces.length-1]}"
			newFile = "#{nspaces[0..nspaces.length-2].join '/'}/#{newFile}"
			console.log "#{oldFile}::#{newFile}"
			r.renameFile oldFile, newFile

	classes: =>
		classes = []
		@mapFiles (file)=>
			contents = fs.readFileSync(file).toString()
			contents = contents.split '\n'
			for line,n in contents
				if line.startsWith 'class'
				then classes.push line
		classes

	renameFile: (file, newFile)=>
		shell "mv #{file} #{newFile}"
		
module.exports = Refactorer

# Quick usage
path = require 'path'
r = new Refactorer
r.replaceWord
	dir: path.resolve './client/'
	inWord: 'view-item.iced'
	outWord: 'view.iced'

###
Rename suffix.

for file in r.appFiles()
	continue if not file.startsWith '/srv/axiscrm/rest/Api'
	oldFile = file
	pathItems = file.split '/'
	newFile = pathItems[pathItems.length-1]
	newFile = newFile.substring 3, newFile.length
	newFile = "Rest#{newFile}"
	pathItems[pathItems.length-1] = newFile
	console.log pathItems.join '/'
	shell "mv #{oldFile} #{newFile}"
###

###
r.mapTemplates (template)=>
	oldTemplate = template
	# Rename the file.
	template = template.split('/')
	templateName = template[template.length-1]
	templateName = templateName.split('_template')[0]
	templateName = "Tpl#{templateName}.iced"
	template[template.length-1] = templateName
	template = template.join '/'
	shell "mv #{oldTemplate} #{template}"
	
###

###
Insert a new line after every class declaration.

r.mapFiles (file)=>
	contents = fs.readFileSync(file).toString()
	contents = contents.split '\n'
	classLineIndex = 0
	for line,n in contents
		if line.startsWith 'class'
			classLineIndex = n
			nextLine = contents[n+1]
			if nextLine is '' then console.log line
			else
				console.log "splice contents at #{n+1}"
				# console.log contents[n+1]
				contents.splice n+1, 0, ''
	contents = contents.join '\n'
	console.log contents
	fs.writeFile file, contents, 'utf-8', (err)->
###
# console.log r.classes()
###
r.mapTemplates (template)->
	# JQ object		 ^
	# col = ""
	$ = cheerio.load readin template

	templateContainer = $('div')
	if templateContainer.attr('class').includes 'col-md-'
		templateContainer = $ templateContainer.html()
	
	console.log $.html()
###
