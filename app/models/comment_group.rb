class CommentGroup < ActiveRecord::Base
  
  belongs_to :root_comment, :class_name => "Comment", :foreign_key => "root_comment_id"
  validates_presence_of :root_comment_id
  
  is_polymorphic
  
  def self.find_entities_readable_by(user, *args)
    find(*args).inject({}) do |hash, comment_group|
      hash[comment_group.entity_type] ||= []
      hash[comment_group.entity_type] << comment_group.entity_id
      hash[comment_group.entity_type].uniq!
      hash
    end.inject([]) do |entities, entity_hash|
      entity_class = entity_hash[0].constantize
      ids = entity_hash[1]
      by_friends = entity_class.by_friends_of user
      if entity_class.has_privacy?
        entities += by_friends.readable_by_anybody.find(:all, :conditions => {:id => ids})
        entities += entity_class.by_mutual_friends_of(user).readable_by_friends.find(:all, :conditions => {:id => ids})
      else
        entities += by_friends
      end
      entities
    end
  end
  
end
