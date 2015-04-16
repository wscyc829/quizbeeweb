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
    PrivatePub.publish_to "/quizbee/create_room", :user => current_user, :rooms => current_user.rooms
  end

  def add_friend
    f = User.where(username: params[:af][:username]).to_a.first
    if f.id != current_user.id
      @friend = current_user.friendships.create(friend_id: f.id)
      
      update

      PrivatePub.publish_to "/quizbee/add_friend", :user => current_user, :friend => f, :rooms => current_user.rooms
    end
  end

  def post_question
    body = params[:pq][:body]
    question = Question.create(user_id: current_user.id, room_id: current_room.id, body: body)
    @questions = current_room.questions

    PrivatePub.publish_to "/quizbee/post_question", :question => question, :user => current_user, :room => current_room
  end

  def post_comment
    body = params[:pc][:body]
    question = Question.find_by(id: params[:pc][:question_id])
    comment = Comment.create(user_id: current_user.id, question_id: question.id, body: body)
    @questions = current_room.questions

    PrivatePub.publish_to "/quizbee/post_comment", :question => question, :comment => comment,
      :user => current_user, :room => current_room
  end
  
  def send_message
    body = params[:sm][:body]
    message = Message.create(user_id: current_user.id, room_id: current_room.id, body: body)
    @messages = current_room.messages

    PrivatePub.publish_to "/quizbee/send_message", :message => message, :user => current_user, :room => current_room
  end

  def switch_room
    session[:room_id] = params[:sr][:room_id]
    @questions = current_room.questions
    @messages = current_room.messages
  end

  def like_comment
    question = Question.find_by(id: params[:question_id])
    comment = Comment.find_by(id: params[:comment_id])

    like = Like.create(user_id: current_user.id, comment_id: comment.id)

    @questions = current_room.questions

    PrivatePub.publish_to "/quizbee/like_or_unlike_comment", :question => question, :comment => comment, 
    :likes => comment.likes.size, :user => current_user, :room => current_room
  end

  def unlike_comment
    question = Question.find_by(id: params[:question_id])
    comment = Comment.find_by(id: params[:comment_id])

    Like.find_by(user_id: current_user.id, comment_id: comment.id).delete
    
    @questions = current_room.questions

     PrivatePub.publish_to "/quizbee/like_or_unlike_comment", :question => question, :comment => comment, 
    :likes => comment.likes.size, :user => current_user, :room => current_room
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
