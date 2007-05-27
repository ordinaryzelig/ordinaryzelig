class Blog < ActiveRecord::Base
  
  belongs_to :user
  has_many :comment_groups, :as => :entity
  has_many :root_comments,
           :class_name => "Comment",
           :through => :comment_groups,
           :order => :created_at
  validates_presence_of :created_at, :title, :body, :user_id
  
  def before_validation_on_create
    self.created_at ||= Time.now.localtime
  end
  
  def latest_comment
    root_comments.map(&:latest).max { |a, b| a.created_at <=> b.created_at }
  end
  
end