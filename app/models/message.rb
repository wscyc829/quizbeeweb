class Message < ActiveRecord::Base
	belongs_to :user, :class_name => 'User'
	belongs_to :room, :class_name => 'Room'

	validates :user_id, presence: true
	validates :room_id, presence: true
	validates :body, presence: true
end
