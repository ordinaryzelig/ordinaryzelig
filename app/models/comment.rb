class Comment < ActiveRecord::Base
  
  acts_as_tree :order => "created_at"
  has_recency :time => :created_at, :user => :user
  can_be_summarized_by :what => :comment, :who => :user, :when => :created_at, :title => proc { entity.title }, :type => proc { "#{self.class} for #{entity.class}" }, :url => proc { entity.summarize_url }
  
  belongs_to :user
  validates_presence_of :comment, :user_id, :created_at
  attr_accessor :entity_type, :entity_id
  
  def before_validation_on_create
    # set created_at time to now.
    self.created_at ||= Time.now.localtime
  end
  
  def validate_on_create
    # if this is a root comment, validates_presence_of :commentable.
    unless parent_id
      errors.add_on_blank(:entity_type)
      errors.add_on_blank(:entity_id)
    end
  end
  
  def after_create
    # raise exception if ROOT comment does not automatically create a CommentGroup.
    raise "comment group not saved" unless parent_id || CommentGroup.new(:root_comment_id => self.id, :entity_type => @entity_type, :entity_id => @entity_id).save
  end
  
  def comment_group
    @comment_group ||= CommentGroup.find_by_root_comment_id(root.id)
  end
  
  def entity
    @entity ||= comment_group.entity
  end
  
  # recursively find the lastest child message.
  def latest_comment
    if children.empty?
      self
    else
      # can't just do Enumerable.max because it won't recurse if there is only one child.
      maxes_of_children = []
      children.each do |child|
        maxes_of_children << child.latest_comment
      end
      maxes_of_children.max{|a, b| a.created_at <=> b.created_at}
    end
  end
  
end