class Friendship < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  belongs_to :considering_friend, :class_name => "User", :foreign_key => "user_id"
  
  validates_presence_of :user, :friend_id
  
  has_recency :user => :friend, :time => :created_at, :block => proc { |user| self.user == user && recency_time_obj >= user.previous_login_at }
  # can_be_summarized_by :who
  
end
