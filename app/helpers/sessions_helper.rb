module SessionsHelper
	def sign_in(user)
		remember_token = user.new_remember_token()
		cookies.permanent[:remember_token] = remember_token
		# update attribute bypasses validations! (Hartl: we do this because we do not have the password?)
		# but sign_in is called with a user object from the SessionsController containing username and password ?!
		user.update_attribute(:remember_token, User.digest(remember_token))
		# just necessary if we want to use sign_in without a redirect
		# a redirect reloads the current user, a rerendering doesn't
		@current_user = user
	end

	# def current_user=(user)
	# 	@current_user = user
	# end

	def current_user
		# more robust in terms of null pointer exceptions
		digest_token = (cookies && cookies[:remember_token]) ? User.digest(cookies[:remember_token]) : nil
		return @current_user ||= (digest_token ? User.find_by(remember_token: digest_token) : nil)
		## this is compact style for
		# return @current_user ? @current_user : User.find_by(...)		
	end

	def signed_in?
		return !current_user.nil?
	end
end
