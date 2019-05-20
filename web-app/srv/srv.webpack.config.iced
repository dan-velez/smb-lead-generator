path = require 'path'
webpack = require 'webpack'
HtmlWebpackPlugin = require 'html-webpack-plugin'
UglifyJSPlugin = require 'uglifyjs-webpack-plugin'

module.exports =
  entry: [
    'webpack-hot-middleware/client?reload=true'
    path.resolve './client/main.jsx'
  ]

  output:
    path: path.resolve './public/'
    filename: '[name].js'
    publicPath: '/'

  plugins: [
    new webpack.HotModuleReplacementPlugin,
    new UglifyJSPlugin()
  ]

  externals: []

  module:
    loaders: [
        test: /\.iced$/
        loader: 'iced-react-loader'
      ,
        test: /\.pug$/
        loader: 'pug--loader'
      ,
        test: /\.jsx$/
        loader: 'babel-loader'
        exclude: /node_modules/
        query:
          presets: ['react', 'es2015']
    ]

# 754 301 4938 - Michelle 
# 561 370 9189 - Greg recruiter WPB
# quence@quest:~/www/tmp2/ebizfi-leadgen$ babel-preset-react
# babel-preset-react: command not found
# quence@quest:~/www/tmp2/ebizfi-leadgen$ npm i !!
