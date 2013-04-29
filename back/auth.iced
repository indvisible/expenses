passport = require 'passport'
User = require './models/user'
GoogleStrategy = require("passport-google-oauth").OAuth2Strategy
util = require 'util'

module.exports = (app) ->
	
	app.use passport.initialize()
	app.use passport.session()

	passport.use new GoogleStrategy
		clientID: "836427388747.apps.googleusercontent.com"
		clientSecret: "lMF07R7txxWa_scy0S1D_y6Y"
		callbackURL: "http://localhost:3000/accept/google/",
		(accessToken, refreshToken, profile, done) ->
			User.getOrCreateByGoogleId
				googleId: profile._json.id,
				email: profile._json.email,
				done()

	passport.serializeUser (user, done) ->
		done null, user._id

	passport.deserializeUser (id, done) ->
		done null, new User _id: id

	authenticate = passport.authenticate "google",
		successRedirect: '/app'
		failureRedirect: '/'
		scope: ['https://www.googleapis.com/auth/userinfo.email']

	app.get "/enter/google", authenticate

	app.get "/accept/google", passport.authenticate("google"), (req, res) ->
		res.redirect "/app"
