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
	      @error = 0
      	  if User.where(username: params[:session][:username]).to_a.size > 0
          	#username exists but wrong password
          	@error = 1
          else
          	#username not exists
          	@error = 2
   		  end
	    end
	end

end
