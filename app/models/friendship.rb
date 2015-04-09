class Friendship < ActiveRecord::Base
	belongs_to :user, :class_name => 'User'
	belongs_to :friend, :class_name => 'User'

	def self.add_friend(user_id, friend_id)

		friend = Friendship.create(user_id: user_id, friend_id: friend_id)
		friend
	end
end