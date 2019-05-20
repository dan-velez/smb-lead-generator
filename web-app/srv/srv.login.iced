bcrypt = require 'bcryptjs'
IcedMongo = require 'axis-db'

class ServerLogin

	constructor: (@app)->
    @app.post '/login', @login
    @app.get '/HttpLogin/logout/:username', @logout
    @db = new IcedMongo process.env.MONGODB_URI
    @db.connect ->

	logout: (req, resp)=>
		console.log "*** logging out #{req.params.username} ***"
		await @db.put 'Users', {username:req.params.username}, {status:'logged out'}, defer()
		resp.json loggedOut:true

	login: (req, resp)=>
		console.log req.body
		await @authCreds req.body.username, req.body.password, defer valid, user
		console.log "auth #{req.body.username} valid: #{if user then true else false}"
		return resp.json {errors:"invalid login"} if not valid
		delete user.hashpass
		# req.session.username = user.name.replace /\s/, ''
		await @db.put 'Users', {username:req.body.username}
		, {status:'logged in'}, defer dbResp
		user.status = 'logged in'
		return resp.json user

	authCreds: (uname, passwd, callb)=>
		await @db.get 'Users', {'username':uname}, defer user
		return callb(false) if !user or typeof user is "array"
		return callb(false) if not user.hashpass
		hash = user.hashpass.toString()
		await bcrypt.compare "#{passwd}", hash, defer h_err, h_resp
		return callb(true, user) if h_resp is true and not h_err
		return callb false

	authReq: (req, callb)=>
		return callb false if not req.session or not req.session.email
		await @authCreds req.session.email, req.session.passwd, defer valid
		return callb false if not valid
		return callb true

module.exports = ServerLogin
