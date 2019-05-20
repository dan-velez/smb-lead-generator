express = require 'express'
path = require 'path'
out = console.log
{ IcedHttpServer } = require 'iced-http'
ServerLogin = require './srv.login'

console.log "INDEX PATH IS " + "#{path.resolve '.'}/public/index.html"

class ServerMain extends IcedHttpServer
  name: 'lead-generator'
  mode: process.env.MODE or 'development'

  install: =>
    out 'mode', @mode
    @indexPath = "#{path.resolve '.'}/public/index.html"
    @app.use express.static path.resolve "./public/"
    # new ServerLogin @app
    switch @mode
      when 'development' then @setupDev()
      when 'production' then @setupProd()
      else throw 'Invalid server mode set, check @mode in ServerMain'

  setupProd: =>
    # Production build
    ###
    compression = require 'compression'
    minify = require 'express-minify'
    @app.use compression threshold:0
    @app.use minify()
    ###
    @app.get '/main.js', @serveProdBuild
    @app.get '/', @serveIndexProd

  serveIndexProd: (req, resp)=>
    resp.sendFile @indexPath

  serveProdBuild: (req, resp)=>
    bundle = path.resolve './public/bundle.prod.js'
    resp.sendFile bundle

  setupDev: =>
    # Webpack
    webpack = require 'webpack'
    webpackConfig = require './srv.webpack.config.js'
    webpackMiddleware = require 'webpack-dev-middleware'
    webpackHotMiddleware = require 'webpack-hot-middleware'
    @compiler = webpack webpackConfig
    @webpackmware = webpackMiddleware @compiler,
      publicPath: webpackConfig.output.publicPath
      contentBase: 'src'
      stats:
        colors: true
        hash: false
        timings: true
        chunks: false
        chunkModules: false
      modules: false
    @app.use  @webpackmware
    @app.use webpackHotMiddleware @compiler
    @app.get '*', @serveIndexDev

  serveIndexDev: (req, resp)=>
      resp.write @webpackmware.fileSystem.readFileSync @indexPath
      resp.end()

new ServerMain port: process.env.PORT or 5000
