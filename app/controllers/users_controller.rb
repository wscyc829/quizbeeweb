class UsersController < ApplicationController
  	skip_before_action :require_login
  	respond_to :html, :js

  	def index
  		@user = User.new
  	end

   	def create
   		p = user_params

      @error = 0
      @error = 1 if User.where(username: p[:username]).to_a.size > 0
      @error = 2 if p[:password] != p[:password_confirmation]

      if @error == 0
      	@user = User.create_user(p[:username], 
      	p[:password], p[:password_confirmation],
      	p[:first_name], p[:last_name])
      else
        @user = false
      end

  	end

  	private

    	def user_params
      		params.require(:user).permit(:username, 
      			:password, :password_confirmation, 
            	:first_name, :last_name)
    	end
end
