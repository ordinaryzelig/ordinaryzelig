class Friendship < ActiveRecord::Base
  
  include ActionView::Helpers::UrlHelper
  
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  belongs_to :considering_friend, :class_name => "User", :foreign_key => "user_id"
  
  validates_presence_of :user_id, :friend_id, :created_at
  
  can_be_marked_as_read
  has_recency
  SCOPES[:considering_friends] = proc { |user| {:conditions => ["#{table_name}.friend_id = ?", user.id]} }
  can_be_summarized_by :title => proc { "#{user.first_last_display} added you as a friend." },
                       :url => proc { {:controller => "user", :action => "profile", :id => user.id} },
                       :who => nil
  can_be_syndicated_by :title => proc { "#{user.first_last} added you as a friend." },
                       :link => proc { {:controller => 'user', :action => 'profile', :id => user.id} }
  is_entity_type
  
  def self.recents(user, *more_scopes)
    all_scopes = [SCOPES[:considering_friends][user],
                  SCOPES[:created_at_since_previous_login][user]] +
                  more_scopes
    @recents = find_all_with_scopes *all_scopes
    @recents.delete_if { |r| user.read_items.entities_since_previous_login.include?(r) }
  end
  
  private
  
  def before_validation_on_create
    self.created_at ||= Time.now.localtime
  end
  
end
