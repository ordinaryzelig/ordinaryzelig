class Blog < ActiveRecord::Base
  
  has_nested_comments
  checks_for_recency :time => :created_at
  
  belongs_to :user
  validates_presence_of :created_at, :title, :body, :user_id
  
  def before_validation_on_create
    self.created_at ||= Time.now.localtime
  end
  
end