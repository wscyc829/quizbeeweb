class Room < ActiveRecord::Base
	has_many :questions, dependent: :destroy
	has_many :messages, dependent: :destroy
	belongs_to :owner, :class_name => 'User'

	validates_uniqueness_of :owner_id, :scope => [:room_name]
	validates :room_name, :owner_id, presence: true

	def self.create_room(room_name, owner_id)
    	return false if Room.where(room_name: room_name, owner_id: owner_id).to_a.size > 0

    	room = Room.create(room_name: room_name, owner_id: owner_id)
    	room
	end
end
