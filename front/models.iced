define ["backbone"], (Backbone) ->

	exports = {}

	exports.Expense = Expense = Backbone.Model.extend
		urlRoot: "expenses"

	exports.FrequentItems = Backbone.Collection.extend
		url: "items"

	exports.FrequentPlaces = Backbone.Collection.extend
		url: "places"

	exports.LatestPrice = Backbone.Model.extend
		url: "prices"

	exports.Login = Backbone.Model.extend
		url: "users"

	exports.Expenses = Backbone.Collection.extend
		url: "expenses"
		getTotalPrice: ->
			reduction = (memo, item) ->
				memo + item.get "price"
			@reduce reduction, 0 

	exports
