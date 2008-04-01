require File.dirname(__FILE__) + '/../test_helper'

class CommentGroupTest < Test::Unit::TestCase
  
  fixtures :comment_groups, :blogs, :messages
  movie_fixtures
  
  def test_find_entities_readable_by
    user = users :ten_cent
    entities = CommentGroup.find_entities_readable_by(user, :all)
    assert entities.size > 0
    entities.each do |entity|
      assert user.can_read?(entity)
    end
  end
  
end
