class Auth
	isLoggedIn: () =>
		return !!window.localStorage.getItem("loggedIn")

	loginIsValid: () =>
		return true

