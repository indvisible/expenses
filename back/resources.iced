async = require "async"
models = require "./models/models"
log = require "./log"

respond = (params) ->
	req = params[0]
	res = params[1]	
	(error, result) ->
		if error
			log.error JSON.stringify ip: req.connection.remoteAddress, error: error
			res.send 500, error
		else
			res.json result

module.exports = 
	expenses:
		index: (req, res) ->
			method = (week: "getThisWeek", month: "getThisMonth")[req.query.range] or "getAll"
			models.Expense[method] respond arguments
		create: (req, res) ->
			async.series [
				(done) -> (new models.Expense req.body).save done
				(done) -> async.parallel [
					(done) -> models.Item.hit req.body.item, done
					(done) -> models.Place.hit req.body.item, req.body.place, done
					(done) -> models.Price.hit req.body.item, req.body.place, req.body.price, done
				], done
			], (error) -> respond([req, res]) error, {}
	items:
		index: (req, res) ->
			models.Item.getFrequent respond arguments
	places:
		index: (req, res) ->
			models.Place.getFrequent req.query.item, respond arguments
	prices:
		index: (req, res) ->
			models.Price.getLatest req.query.item, req.query.place, (error, price) ->
				respond([req, res]) error, price
	users:
		create: (req, res) ->
			console.log "creating user credentials"
			await models.User.createCredentials req.body.password, defer err, credentials
			console.log "before save user"
			new models.User(
				username: req.body.username,
				email: req.body.email,
				passwordSalt: credentials.Salt,
				passwordHash: credentials.Hash
			).save respond(arguments)