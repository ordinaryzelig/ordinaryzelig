class Friendship < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  belongs_to :considering_friend, :class_name => "User", :foreign_key => "user_id"
  can_be_marked_as_read
  
  validates_presence_of :user_id, :friend_id, :created_at
  
  has_recency do |user|
    friend == user && created_at >= user.previous_login_at
  end
  can_be_summarized_by :title => proc { "#{user.first_last_display} added you as a friend." },
                       :url => proc { {:controller => "user", :action => "profile", :id => user.id} },
                       :who => nil
  can_be_syndicated_by :title => proc { "#{user.first_last} added you as a friend." },
                       :link => proc { {:controller => 'user', :action => 'profile', :id => user.id} }
  
  include ActionView::Helpers::UrlHelper
  
  def before_validation_on_create
    self.created_at ||= Time.now.localtime
  end
  
  def self.recents(user)
    find_all_with_scopes *[{:conditions => ["#{table_name}.friend_id = ?", user.id]},
                           {:conditions => ["#{table_name}.#{recency_time_obj_name} > ?", user.previous_login_at]}]
  end
  
end
