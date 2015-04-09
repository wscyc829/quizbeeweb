module ApplicationHelper

	def current_room
		@current_room ||= Room.find_by(id: session[:room_id])
 	end

  def entered?
  	if !session[:room_id].nil?
  		!current_room.nil?
  	else
  		false
  	end
	end

  def exit
  	session.delete(:room_id)
   	@current_room = nil
  end
end
