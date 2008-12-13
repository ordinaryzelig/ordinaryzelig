require File.dirname(__FILE__) + '/../test_helper'

class CommentGroupTest < ActiveSupport::TestCase
  
  fixtures :blogs, :comment_groups, :messages, :privacy_levels
  movie_fixtures
  
  def test_find_by_entities_readable_by
    user = users :ten_cent
    comment_groups = CommentGroup.find_by_entities_readable_by(user)
    assert comment_groups.size > 0, 'no comment_groups found.'
    comment_groups.each do |cg|
      assert user.can_read?(cg.entity)
    end
  end
  
end
