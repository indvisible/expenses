express = require "express"
log = require "./log"
lessCompiler = require "./lessCompiler"
icedCompiler = require "./icedCompiler"
require "express-resource"
resources = require "./resources"
mongoose = require "mongoose"
models = require "./models/models"
auth = require "./auth"
http = require 'http'
bus = require './bus'

connectionString = process.env.CONNECTION_STRING or "mongodb://localhost/expenses"
port = process.env.PORT or 3000

mongoose.connect connectionString, (error) ->
	log.error error if error
	log.info "Connected to #{connectionString}." unless error

app = express()
server = http.createServer app

frontDir = __dirname + "/../front"

app.use express.static(frontDir + "/lib")
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.session
  secret: "expenses-app"

app.use lessCompiler frontDir
app.use icedCompiler frontDir

app.use auth

app.set "view engine", "jade"
app.set "views", frontDir

app.get "/", (req, res) ->
	res.render "app"

#guard = (req, res, next) ->
#	return res.send 403 if not req.isAuthenticated()
#	next()
#handle403 = (err, req, res, next)->
#  if err.status != 403
#    next()
#  log.info "Not authorised!"

#app.all "/expenses", guard
#app.use handle403

app.resource "expenses", resources.expenses
app.resource "users", resources.users
app.resource "items", resources.items
app.resource "places", resources.places
app.resource "prices", resources.prices

server.listen port, -> 
	log.info "Listening on #{port}..."
