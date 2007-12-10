class Blog < ActiveRecord::Base
  
  belongs_to :user
  
  validates_presence_of :title, :body, :user_id
  
  attr_accessible :title, :body
  
  has_nested_comments
  has_recency
  can_be_summarized_by :what => :body, :title => :title, :when => :created_at
  can_be_syndicated_by :title => proc { "Blog: #{title}" }, :description => :body
  preview_using :body
  can_be_marked_as_read
  is_entity_type
  has_privacy
  
end
