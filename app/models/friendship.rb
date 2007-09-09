class Friendship < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  belongs_to :considering_friend, :class_name => "User", :foreign_key => "user_id"
  
  validates_presence_of :user_id, :friend_id, :created_at
  
  has_recency :block => proc { |user| friend == user && created_at >= user.previous_login_at }
  can_be_summarized_by :title => proc { "#{user.first_last_display} added you as a friend." },
                       :url => proc { {:controller => "user", :action => "profile", :id => user.id} },
                       :who => nil
  
  def before_validation_on_create
    self.created_at ||= Time.now.localtime
  end
  
  def self.recents(user)
    find(:all, :include => [:user, :friend]).select { |friendship| friendship.is_recent?(user) }
  end
  
end
