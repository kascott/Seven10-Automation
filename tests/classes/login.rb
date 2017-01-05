class Login

	def loginInfo(browser,username,password)
		@b = browser
		@username = username
		@password = password
		@b.element(:css => '[ng-model="login.username"]').wait_until_present(15)
		@b.element(:css => '[ng-model="login.username"]').send_keys(@username)
		@b.element(:css => '[ng-model="login.password"]').send_keys(@password)
		@b.button(:value => 'Sign In').click()
		Watir::Wait.until { @b.text.include? 'Dashboard' }
	end

end