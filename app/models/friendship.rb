class Friendship < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  belongs_to :considering_friend, :class_name => "User", :foreign_key => "user_id"
  
  validates_presence_of :user, :friend_id
  
end
