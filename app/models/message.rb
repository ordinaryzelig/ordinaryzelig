class Message < ActiveRecord::Base
  
  acts_as_tree
  has_nested_comments
  has_recency
  can_be_summarized_by :what => :body, :who => :user, :when => :created_at, :max => 100, :title => :subject, :url => proc { {:controller => "message_board", :action => "show", :id => self.id} }
  can_be_syndicated_by :title => :subject,
                       :link => proc { {:controller => 'message_board', :action => 'show', :id => id} },
                       :description => :body,
                       :pubdate => :created_at,
                       :author => :user
  preview_using :body
  can_be_marked_as_read
  nil_if_blank
  
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  validates_presence_of :user_id, :created_at
  validates_presence_of :subject
  validates_presence_of :body
  validates_length_of :subject, :maximum => 100
  
  def before_validation_on_create
    self.created_at ||= Time.now.localtime
  end
  
end
