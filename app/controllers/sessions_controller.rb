class SessionsController < ApplicationController
	skip_before_action :require_login
	respond_to :html, :js

	include SessionsHelper
	
	def index

	end

	def login
		user = User.authenticate(params[:session][:username], params[:session][:password])
	    if user
	      # Log the user in and redirect to the user's show page.
	      log_in user
	    else
	      # Create an error message.
	      	flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
	    end
	end

end
