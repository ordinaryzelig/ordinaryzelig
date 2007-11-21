class Blog < ActiveRecord::Base
  
  belongs_to :user
  has_one :privacy_level, :as => :entity
  
  validates_presence_of :created_at, :title, :body, :user_id
  
  attr_accessible :title, :body
  
  has_nested_comments
  has_recency
  can_be_summarized_by :what => :body, :title => :title, :when => :created_at
  can_be_syndicated_by :title => proc { "Blog: #{title}" }, :description => :body
  preview_using :body
  can_be_marked_as_read
  is_entity_type
  
  def before_validation_on_create
    self.created_at ||= Time.now.localtime
  end
  
end
