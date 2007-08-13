class Friendship < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  belongs_to :considering_friend, :class_name => "User", :foreign_key => "user_id"
  
  validates_presence_of :user_id, :friend_id, :created_at
  
  has_recency :user => :friend, :time => :created_at, :block => proc { |user| recency_user_obj == user && user.previous_login_at && recency_time_obj >= user.previous_login_at }
  can_be_summarized_by :title => proc { "#{user.first_last_display} added you as a friend." },
                       :url => proc { {:controller => "user", :action => "profile", :id => user.id} },
                       :who => nil
  
  def before_validation_on_create
    self.created_at ||= Time.now.localtime
  end
  
end
