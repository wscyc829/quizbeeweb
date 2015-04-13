class Friendship < ActiveRecord::Base
	belongs_to :user, :class_name => 'User'
	belongs_to :friend, :class_name => 'User'
	validate :add_self_validation

	def self.add_friend(user_id, friend_id)

		friend = Friendship.create(user_id: user_id, friend_id: friend_id)
		friend
	end

    def add_self_validation
        if self.user.id == self.friend.id
            errors.add_to_base("Can't your self as friend") 
        end
    end
end