define ["routing", "controllers"], (routing, controllers) ->

	RouteCollection = routing.RouteCollection

	new routing.RouteTable [
		new RouteCollection
			appRoutes:
				"main-menu": url: "", action: "showMenu"
				"history": url: "history/:range", action: "showHistory", range: "week"
			controller: controllers.MainMenuController
		new RouteCollection
			appRoutes:
				"add-expense-items": url: "add", action: "showFrequentItems"
				"add-expense-places": url: "add/:item", action: "showFrequentPlaces", item: null
				"add-expense-editor": url: "add/:item/:place", action: "showExpenseEditor", item: null, place: null
			controller: controllers.ExpenseWizardController
		new RouteCollection
			appRoutes:
				"analytics": url: "history", action: "showHistory"
			controller:
				controllers.HistoryController
		new RouteCollection
			appRoutes:
				"login": url: "login", action: "showLogin"
				"sing-up": url: "signup", action: "showSignUp"
			controller:
				controllers.AuthController
	]
