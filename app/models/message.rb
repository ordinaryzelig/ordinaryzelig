class Message < ActiveRecord::Base
  
  acts_as_tree
  has_nested_comments
  has_recency :time => :posted_at, :user => :poster
  can_be_summarized_by :what => :body, :who => :poster, :when => :posted_at, :max => 100, :title => :subject, :url => proc { {:controller => "message_board", :action => "show", :id => self.id} }
  
  belongs_to :poster, :class_name => "User", :foreign_key => "posted_by_user_id"
  validates_presence_of :posted_by_user_id, :posted_at
  validates_presence_of :subject
  validates_presence_of :body
  validates_length_of :subject, :maximum => 100
  
  def before_validation_on_create
    self.posted_at ||= Time.now.localtime
  end
  
end