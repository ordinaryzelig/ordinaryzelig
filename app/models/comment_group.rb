class CommentGroup < ActiveRecord::Base
  
  belongs_to :root_comment, :class_name => "Comment", :foreign_key => "root_comment_id"
  validates_presence_of :root_comment_id
  
  is_polymorphic
  
  # since this is a polymorphic model,
  # have to do some manual work before querying the database.
  # for however many uniq polymorphic models there are, that's how many queries we run.
  # return an array of all the results.
  def self.find_entities_readable_by(user, *args)
    args = :all if args.empty?
    find(*args).group_by(&:entity_type).inject([]) do |entities, entity_type_and_comment_groups|
      entity_class = entity_type_and_comment_groups.first.constantize
      ids = entity_type_and_comment_groups.last.map(&:entity_id)
      if entity_class.has_privacy?
        entities += entity_class.readable_by_anybody.find(:all, :conditions => {:id => ids})
        entities += entity_class.by_mutual_friends_of(user).readable_by_friends.find(:all, :conditions => {:id => ids})
      else
        entities += entity_class.find(ids)
      end
      entities
    end
  end
  
end
