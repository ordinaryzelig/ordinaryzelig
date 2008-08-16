class Comment < ActiveRecord::Base
  
  acts_as_tree :order => "created_at"
  
  belongs_to :user
  has_one :comment_group, :foreign_key => "root_comment_id"
  
  validates_presence_of :comment, :user_id
  validate_on_create :validate_entity_or_parent
  after_create :create_comment_group
  
  attr_protected :user_id, :created_at
  attr_accessor :entity_type, :entity_id
  
  has_recency
  can_be_summarized_by :what => :comment,
                       :title => proc { "#{entity.class}: #{entity.summarize_title}" },
                       :url => proc { self.entity.summarize_url },
                       :when => :created_at
  can_be_syndicated_by :title => proc { "comment for #{entity.class}: #{entity.summarize_title}" },
                       :link => proc { entity.syndicate_link },
                       :description => proc { comment }
  preview_using :comment
  can_be_marked_as_read
  is_entity_type
  
  def comment_group
    @comment_group ||= CommentGroup.find_by_root_comment_id(root.id)
  end
  
  def entity
    @entity ||= comment_group.entity
  end
  
  def self.recents_to(user)
    recents = by_friends_of(user).since_previous_login(user) - read_by(user)
    readable_comment_groups = CommentGroup.find_by_entities_readable_by(user, recents.map { |comment| comment.comment_group.id })
    recents.select { |r| readable_comment_groups.include?(r.comment_group) }
  end
  
  private
  
  def validate_entity_or_parent
    unless parent_id
      errors.add_on_blank(:entity_type)
      errors.add_on_blank(:entity_id)
    end
  end
  
  def create_comment_group
    # raise exception if ROOT comment does not automatically create a CommentGroup.
    CommentGroup.new(:root_comment_id => self.id, :entity_type => @entity_type, :entity_id => @entity_id).save! unless parent_id
  end
  
end
