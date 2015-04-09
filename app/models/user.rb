class User < ActiveRecord::Base
  has_many :rooms, :class_name => 'Room', :foreign_key => 'owner_id', dependent: :destroy
  has_many :users, :class_name => 'Friendship', :foreign_key => 'friend_id', dependent: :destroy
  has_many :friends, :class_name => 'Friendship', :foreign_key => 'user_id', dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  validates :username, presence: true, uniqueness: true
  validates :password_hash, presence: true
  validates :salt, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates_uniqueness_of :first_name, :scope => [:last_name]

  def self.create_user(username, password, password_confirm, first_name, last_name)
    return false if password != password_confirm
    return false if User.where(username: username).to_a.size > 0

    salt = BCrypt::Engine.generate_salt
    hashed_password = BCrypt::Engine.hash_secret(
      password, salt)
    new_user = User.create(username: username,
        password_hash: hashed_password, salt: salt, first_name: first_name, last_name: last_name)
    new_user
  end

  def self.authenticate(username, password)
    user = User.where(username: username).first
    if user.present? && user.password_hash == BCrypt::Engine.hash_secret(password, user.salt)
      user
    else
      nil
    end
  end
end
