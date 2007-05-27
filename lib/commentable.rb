module Commentable
  
  def comments
    comment_groups.map { |cg| cg.root_comment }
  end
  
end