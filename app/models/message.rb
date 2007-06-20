class Message < ActiveRecord::Base
  
  acts_as_tree
  has_nested_comments
  
  belongs_to :poster, :class_name => "User", :foreign_key => "posted_by_user_id"
  validates_presence_of :posted_by_user_id, :posted_at
  
  def validate
    errors.add_on_blank(:subject)
    errors.add_on_blank(:body)
    errors.add(:subject, "subject too long, max 100 characters.") if @subject && @subject.length > 100
  end
  
  def before_validation_on_create
    self.posted_at = Time.now.localtime
  end
  
  def to_comment
    case ancestors.size
    when 0
      children.each(&:to_comment)
    when 1
      comment = Comment.new(:comment => "#{self.subject}<br><br>#{self.body}",
                            :user => self.poster,
                            :created_at => self.posted_at,
                            :entity_type => parent.class.to_s,
                            :entity_id => parent.id)
      comment.save
      comment.children = children.map(&:to_comment)
      comment.save
    else
      comment = Comment.new(:comment => "#{self.subject}<br><br>#{self.body}",
                            :user => self.poster,
                            :created_at => self.posted_at)
      comment.save
      comment.children = children.map(&:to_comment)
      comment.save
    end
    comment
  end
  
end