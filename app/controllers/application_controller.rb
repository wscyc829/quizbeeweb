class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login
  respond_to :html, :js

  include SessionsHelper, ApplicationHelper

  def index
    @room = Room.new

    @friend = Friendship.new
    
    update

  end

  def logout
      exit if entered?
      log_out if logged_in?
      redirect_to login_path
  end

  
  def create_room
    @room = current_user.rooms.create!(room_name: params[:cr][:room_name])
    
    update
  end

  def add_friend
    f = User.where(first_name: params[:af][:first_name],
                          last_name: params[:af][:last_name]).to_a.first
    @friend = current_user.friendships.create(friend_id: f.id)
    
    update
  end

  def post_question
    body = params[:pq][:body]
    Question.create(user_id: current_user.id, room_id: current_room.id, body: body)
    @questions = current_room.questions
  end

  def post_comment
    body = params[:pc][:body]
    question = Question.find_by(id: params[:pc][:question_id])
    Comment.create(user_id: current_user.id, question_id: question.id, body: body)
    @questions = current_room.questions
  end
  
  def send_message
    body = params[:sm][:body]
    Message.create(user_id: current_user.id, room_id: current_room.id, body: body)
    @messages = current_room.messages

  end

  def switch_room
    session[:room_id] = params[:sr][:room_id]
    @questions = current_room.questions
    @messages = current_room.messages
  end

  def like_comment
    comment_id = params[:comment_id]
    Like.create(user_id: current_user.id, comment_id: comment_id)
    @questions = current_room.questions
  end

  def unlike_comment
    comment_id = params[:comment_id]
    Like.find_by(user_id: current_user.id, comment_id: comment_id).destroy
    
    @questions = current_room.questions
  end

  private

    def require_login
    	redirect_to login_path if session[:user_id].nil?
    end

    def update
      @rooms = current_user.rooms

      @friends = Array.new

      friendships = current_user.friendships + current_user.users

      friendships.each do |f|
        if f.friend.id == current_user.id
          @friends.push(f.user)
          @rooms += f.user.rooms
        else
          @friends.push(f.friend)
          @rooms += f.friend.rooms
        end
      end

      if entered?
        @questions = current_room.questions
        @messages = current_room.messages
      end
  end
end
