class Message < ActiveRecord::Base
  
  acts_as_tree
  has_nested_comments
  has_recency :time => :posted_at, :user => :poster
  
  belongs_to :poster, :class_name => "User", :foreign_key => "posted_by_user_id"
  validates_presence_of :posted_by_user_id, :posted_at
  validates_presence_of :subject
  validates_presence_of :body
  validates_length_of :subject, :maximum => 100
  
  def before_validation_on_create
    self.posted_at ||= Time.now.localtime
  end
  
  def is_recent?(user)
    if user.user_activity
      posted_at > user.user_activity.previous_login_at ||
      (latest_comment && latest_comment.created_at > user.user_activity.previous_login_at)
    end
  end
  
  def owned_by?(user)
    user == poster
  end
  
end