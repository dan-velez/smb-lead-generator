# TODO fork this to a seperate proceess. Large file uploads block the event loop

class AppHttpUploadFiles

	constructor: (@app, @db)->
		@app.post '/UploadSubDocs', @uploadSubDoc

	uploadSubDoc: (req, resp)=>
		# Upload a document to the SubDocs collection in the Mongo db.
		out "Uploading a submission document:"
		out req.body
		meta = req.body
		file = req.files[meta.name]
		meta.file = file
		await @db.post 'SubDocs', meta, defer dbResp
		resp.json mesg:'doc uploaded'

module.exports = AppHttpUploadFiles
