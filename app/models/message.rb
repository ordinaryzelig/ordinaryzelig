class Message < ActiveRecord::Base
  
  acts_as_tree
  
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
  
  def num_replies
    count = 0
    count += children.size
    children.each {|child| count += child.num_replies}
    count
  end
  
  def self.root_messages_by_latest
    roots = []
    all = Message.find(:all, :order => "#{Message.table_name}.posted_at DESC")
    all.each do |m|
      if roots.include?(m.root)
        next
      else
        roots << m.root
      end
    end
    roots
  end
  
  # recursively find the lastest child message.
  def latest_message
    if children.empty?
      @latest_message = self
    else
      # can't just do Enumerable.max because it won't recurse if there is only one child.
      maxes_of_children = []
      children.each do |child|
        maxes_of_children << child.latest_message
      end
      @latest_message = maxes_of_children.max{|a, b| a.posted_at <=> b.posted_at}
    end
  end
  
end