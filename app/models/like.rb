class Like < ActiveRecord::Base
	belongs_to :user, :class_name => 'User'
	belongs_to :comment, :class_name => 'Comment'

	validates_uniqueness_of :user_id, :scope => [:comment_id]
end
