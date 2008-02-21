class Message < ActiveRecord::Base
  
  acts_as_tree
  
  belongs_to :user
  
  validates_presence_of :user_id
  validates_presence_of :subject
  validates_presence_of :body
  validates_length_of :subject, :maximum => 100
  
  attr_accessible :subject, :body
  
  has_nested_comments
  has_recency
  can_be_summarized_by :what => :body,
                       :max => 100,
                       :title => :subject,
                       :url => proc { {:controller => "message_board", :action => "show", :id => self.id} }
  can_be_syndicated_by :title => :subject,
                       :link => proc { {:controller => 'message_board', :action => 'show', :id => id} },
                       :description => :body,
                       :pubdate => :created_at,
                       :author => :user
  preview_using :body
  can_be_marked_as_read
  nil_if_blank
  is_entity_type
  
end
