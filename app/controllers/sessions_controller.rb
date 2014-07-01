class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by(email: params[:sessions][:email].downcase)
		if user && user.authenticate(params[:sessions][:password])
			# render profile page
			sign_in user
			redirect_back_or user
		else
			# render sign in page again and show errors
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
