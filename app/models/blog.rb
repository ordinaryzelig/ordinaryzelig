class Blog < ActiveRecord::Base
  
  has_nested_comments
  has_recency
  can_be_summarized_by :what => :body, :title => :title, :when => :created_at
  can_be_syndicated_by :title => proc { "Blog: #{title}" }, :description => :body
  preview_using :body
  can_be_marked_as_read
  
  belongs_to :user
  validates_presence_of :created_at, :title, :body, :user_id
  
  attr_accessible :title, :body
  
  def before_validation_on_create
    self.created_at ||= Time.now.localtime
  end
  
end
