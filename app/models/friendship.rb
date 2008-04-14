class Friendship < ActiveRecord::Base
  
  include ActionView::Helpers::UrlHelper
  
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  belongs_to :considering_friend, :class_name => "User", :foreign_key => "user_id"
  
  validates_presence_of :user_id, :friend_id
  
  attr_accessible :user_id, :friend_id
  
  can_be_marked_as_read
  has_recency
  can_be_summarized_by :title => proc { "#{user.first_last_display} added you as a friend." },
                       :url => proc { {:controller => "user", :action => "profile", :id => user.id} },
                       :who => nil,
                       :when => :created_at
  can_be_syndicated_by :title => proc { "#{user.first_last} added you as a friend." },
                       :link => proc { {:controller => 'user', :action => 'profile', :id => user.id} }
  is_entity_type
  
  def self.recents_to(user)
    by_considering_friends_of(user).since_previous_login(user) - read_by(user)
  end
  
end
