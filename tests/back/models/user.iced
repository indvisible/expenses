User = require '../../../back/models/user'
mongoose = require 'mongoose'
async = require "async"
sinon = require 'sinon'
should = require 'should'

describe "User", ->

	clock = null
	now = new Date 2012, 3, 20

	before ->
		clock = sinon.useFakeTimers now.getTime()

	after ->
		clock.restore()

	before (done) ->
		async.series [
			(done) -> User.removeAll done
			(done) -> 
				async.parallel [
					(done) -> (new User email: "bob@gmail.com").save done
					(done) -> (new User email: "peter@gmail.com").save done
					(done) -> (new User email: "mike@gmail.com", username: "Mike").save done
				], done
			], done

	describe "#getByEmail()", ->

		it "should return user by their email", (done) ->
			User.getByEmail "bob@gmail.com", (error, user) ->
				user.email.should.eql "bob@gmail.com"
				done()
	describe "#getOrCreateByGoogleId()", ->

		it "should create user with GoggleId if it's not present", (done) ->
			params = 
				googleId: "3l5jhkg235hjt545",
				email: "greatnewemail@gmail.com"
			User.getOrCreateByGoogleId params, (error, user) ->
				throw error if error?
			User.getByEmail "greatnewemail@gmail.com", (error, user) ->
				user.email.should.eql "greatnewemail@gmail.com"
				user.googleId.should.eql "3l5jhkg235hjt545"
				done()

	describe "#getByUserNameOrEmail()", ->
		it "should get user with login", (done) ->
			User.getByUserNameOrEmail username: "mike@gmail.com", (error, user) ->
				user.email.should.eql "mike@gmail.com"
			done()

		it "should get user with email", (done) ->
			User.getByUserNameOrEmail username: "Mike", (error, user) ->
				user.email.should.eql "mike@gmail.com"
			done()

	describe "#save()", ->

		it "should perform lower case conversion of email and username on save", (done) ->
			model = new User
				email: "SomeGreatEmail@GMAIL.Com"
				username: "MyUsername"
			model.save (error) ->
				model.email.should.eql "somegreatemail@gmail.com"
				model.username.should.eql "myusername"
				done()