class Sync
	constructor: () ->
		$(document).ajaxError(
			(e, jqxhr, settings, exception) ->
				$.mobile.hidePageLoadingMsg()
				alert("AJAX Error: " + exception.toString())
		);

	upload: (fileData) =>
		$('#info-bar').text('Uploading...')

		username = window.localStorage.getItem("username")
		token = window.localStorage.getItem("token")
		$.post(
		  window.SERVER_URL + '/api/upload'
		  {'file' : fileData, 'nobase64' : true, 'username' : username, 'auth_token': token}
		  (data) -> $('#info-bar').text(data)
		  'html'
		)

	login: () =>
		username = $('#user').val()
		password = $('#pass').val()
		$.mobile.showPageLoadingMsg("b", "Logging in...", false)
		$.post(
		  window.SERVER_URL + '/api/login'
		  { 'username' : username, 'password' : password }
		  (data) ->
		  	auth = new Auth
		  	if auth.loginIsValid()
		  		window.localStorage.setItem("loggedIn", true)
		  		window.localStorage.setItem("token", $.parseJSON(data).token)
		  		alert($.parseJSON(data).token)
		  		window.localStorage.setItem("username", username)
		  		$.mobile.hidePageLoadingMsg()
		  		$.mobile.changePage("index.html")
		  	else
		  		$.mobile.hidePageLoadingMsg();
		  		alert("invalid login")		  	
		  'html'
		)		

	loginIsValid: () =>
		return true

	logout: () =>
		username = window.localStorage.getItem("username")
		$.mobile.showPageLoadingMsg("b", "Logging in...", false)
		$.post(
		  window.SERVER_URL + '/api/login'
		  { 'username': username, 'logout': true }
		  (data) ->
	  		window.localStorage.setItem("loggedIn", false)
	  		window.localStorage.setItem("token", null)
	  		window.localStorage.setItem("username", null)
	  		new Grid().processLogin()
	  		$.mobile.hidePageLoadingMsg()
		  'html'
		)		

		