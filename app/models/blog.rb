class Blog < ActiveRecord::Base
  
  has_nested_comments
  has_recency :time => :created_at, :user => :user
  can_be_summarized_by :what => :body, :who => :user, :when => :created_at, :title => :title
  
  belongs_to :user
  validates_presence_of :created_at, :title, :body, :user_id
  
  def before_validation_on_create
    self.created_at ||= Time.now.localtime
  end
  
end