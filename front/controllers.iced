define ["bus", "views", "models"], (bus, views, models) ->

	exports = {}

	exports.MainMenuController =
		showMenu: ->
			bus.trigger "show", new views.MainMenu
		showHistory: (range) ->
			expenses = new models.Expenses
			bus.trigger "show", new views.Expenses collection: expenses
			expenses.fetch data: range: range

	exports.ExpenseWizardController =
		showFrequentItems: ->
			items = new models.FrequentItems

			items.on "selected", (model) -> 
				bus.trigger "navigate", "add-expense-places", item: model.get "name"
			items.on "skipped", ->
				bus.trigger "navigate", "add-expense-editor"

			bus.trigger "show", new views.Options collection: items
			
			items.fetch()

		showFrequentPlaces: (item) ->
			places = new models.FrequentPlaces
			
			places.on "selected", (model) -> 
				bus.trigger "navigate", "add-expense-editor", item: item, place: model.get "name"
			places.on "skipped", ->
				bus.trigger "navigate", "add-expense-editor", item: item

			bus.trigger "show", new views.Options collection: places

			if item
				places.fetch 
					data: 
						item: item

		showExpenseEditor: (item, place) ->
			price = new models.LatestPrice
			
			model = new models.Expense
				item: item
				place: place

			view = new views.ExpenseEditor
				model: model

			view.on "done", ->
				model.save()
				bus.trigger "navigate", "main-menu"
		
			bus.trigger "show", view

			price.on "change", ->
				model.set "price", price.get "value"

			if item and place
				price.fetch
					data: 
						item: item 
						place: place

	exports.AuthController = 
		showLogin: ->
			bus.trigger "show", new views.Login
		showSignUp: ->
			view = new views.SignUp 
				model: new models.Login
			bus.trigger "show", view

			view.on "done", ->
				view.model.save()
				bus.trigger "navigate", "#success"

	exports.HistoryController = 
		showHistory:->
			layout = new views.StatisticsLayout
			bus.trigger "show", layout

			lastExpenses = new models.Expenses

			layout.history.show new views.History collection: lastExpenses

			layout.chart.show new views.Chart collection: lastExpenses

			lastExpenses.fetch()

	exports
