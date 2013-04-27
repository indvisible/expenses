passport = require 'passport'
models = require "./models/models"
Backdoor = require './backdoor'
LocalStrategy = require('passport-local').Strategy

LocalStrategy = new LocalStrategy(
  (username, password, done) ->
    User.getByUsernameOrEmail parameter: username
    , (err, user) ->
      return done(err) if err
      return done(null, false) unless user
      return done(null, false) unless user.verifyPassword(password)
      done null, user
)

passport.initialize()
passport.session()

#passport.use Backdoor
passport.use LocalStrategy

passport.use 

passport.serializeUser (user, done) ->
  done null, user._id

passport.deserializeUser (obj, done) ->
  models.User.getById obj, (err, user) ->
    done null, user

logout = (req, res) ->
    req.logout()
    res.redirect('/')

login = (req, res) ->
  passport.authenticate(
    'local', 
    failureRedirect: '/error' )
  (req, res) ->
    res.redirect '/'

signUp = (req, res) ->


module.exports = (req, res, next) ->
  switch req.url
    when "/logout"
      logout req, res
    when "/login" and req.method == 'POST'
      login req, res
    else
      next()
