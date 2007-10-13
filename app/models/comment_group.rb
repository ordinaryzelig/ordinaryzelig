=begin
designates an entity's root comment.
=end


class CommentGroup < ActiveRecord::Base
  
  belongs_to :root_comment, :class_name => "Comment", :foreign_key => "root_comment_id"
  validates_presence_of :root_comment_id
  
  is_polymorphic
  
end