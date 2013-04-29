mongoose = require 'mongoose'
bcrypt = require 'bcrypt'

User = mongoose.Schema
	username:
		type: String
	email:
		type: String
	passwordHash:
		type: String
	passwordSalt:
		type: String
	googleId:
		type: String

User.statics.getByEmail = (email, done) ->
	@findOne(email: email).exec done

User.statics.getByUsernameOrEmail = (login, done) ->
	query = $or: [
		{username : login}
		{email: login}
	]
	@findOne(query).exec done

User.statics.getById = (userId, done) ->
	@findOne(_id: userId).exec done

User.statics.getOrCreateByGoogleId = (params, done) ->
	query = googleId: params.googleId
	options = upsert: true
	sort = {}
	update = $set: 
		googleId: params.googleId
		email: params.email
	@collection.findAndModify query, sort, update, options, done

User.statics.removeAll = (done) ->
	@collection.remove {}, {w: 0}, done

User.statics.createCredentials = (password, done) ->
	bcrypt.genSalt 15, 25, (err, salt) ->
		bcrypt.hash password, salt, (err, hash)->
			credentials = {
					Salt: salt,
					Hash: hash
				}
			done null, credentials

User.statics.comparePassword = (user, password, done) ->
	bcrypt.compare password, user.passwordHash, (err, res) ->
		if err?
			return done "password is not matched", false 
		done null, true


User.pre "save", (next) ->
	@username = @username?.toLowerCase()
	@email = @email?.toLowerCase()
	next()

module.exports = mongoose.model "users", User
