class UsersController < ApplicationController
  	skip_before_action :require_login
  	respond_to :html, :js

  	def index
  		@user = User.new
  	end

   	def create
   		p = user_params

    	@user = User.create_user(p[:username], 
    	p[:password], p[:password_confirmation],
    	p[:first_name], p[:last_name])
 		
  	end

  	private

    	def user_params
      		params.require(:user).permit(:username, 
      			:password, :password_confirmation, 
            	:first_name, :last_name)
    	end
end
