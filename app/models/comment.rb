class Comment < ActiveRecord::Base
  
  acts_as_tree :order => "created_at"
  has_recency
  can_be_summarized_by :who => :user, :what => :comment, :when => :created_at, :title => proc { "#{entity.class}: #{entity.summarize_title}" }, :url => proc { self.entity.summarize_url }
  can_be_syndicated_by :title => proc { "comment for #{entity.class}: #{entity.summarize_title}" }, :link => proc { entity.syndicate_link }, :description => proc { comment }
  preview_using :comment
  can_be_marked_as_read
  is_entity_type
  
  belongs_to :user
  validates_presence_of :comment, :user_id, :created_at
  
  attr_protected :user_id, :created_at
  attr_accessor :entity_type, :entity_id
  
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
  
  def self.recents(user, *more_scopes)
    all_scopes = [scopes[:friends][user], scopes[:since_previous_login][user]]
    recents = find_all_unread_by_user user, *(all_scopes + more_scopes)
    entities = recents.map(&:entity).uniq
    entities = entities.select { |e| user.can_read? e }
    recents.select { |r| entities.include? r.entity }
  end
  
  private
  
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
    CommentGroup.new(:root_comment_id => self.id, :entity_type => @entity_type, :entity_id => @entity_id).save! unless parent_id
  end
  
end
