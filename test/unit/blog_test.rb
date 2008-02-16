require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < Test::Unit::TestCase
  
  fixtures :blogs
  fixtures :users, :user_activities, :friendships
  
  defaults_for Blog,
               {:title => 'i killed heath ledger',
                :body => 'just watched brokeback mountain and dark knight looks badass.',
                :user_id => 2},
               [:title, :body]
  test_created_at
  test_mark_as_read Blog
  test_privacy_creation
  
  def test_summary
    b = test_new_with_default_attributes
    assert defaults[:body].size > b.summarize_max
    assert_equal b.summarize_what, b.body[0..b.summarize_max]
    assert_equal b.summarize_title, b.title
    assert_equal b.summarize_when, b.created_at
    assert_equal b.summarize_who, b.user
  end
  
  def test_syndication
    b = test_new_with_default_attributes
    assert_equal b.syndicate_title, "Blog: #{b.title}"
    assert_equal b.syndicate_link, {:controller => 'blog', :action => :show, :id => b.id}
    assert_equal b.syndicate_description, b.body
    assert_equal b.syndicate_pubdate, b.created_at
    assert_equal b.syndicate_guid, "Blog_#{b.id}"
    assert_equal b.syndicate_author, b.user
  end
  
  def test_preview
    b = test_new_with_default_attributes
    assert_equal b.preview, b.body
  end
  
  def test_recency
    user = users(:ten_cent)
    user.previous_login_at =  1.second.ago
    friend = user.friends.first
    obj = new_with_default_attributes
    friend.blogs << obj
    assert_not obj.new_record?
    
    # not friends, so shouldn't be recent.
    assert_equal obj.privacy_level.privacy_level_type_id, 2
    assert_not Blog.recents(user).include?(obj)
    
    obj.set_privacy_level! 3
    assert_equal obj.privacy_level.privacy_level_type_id, 3
    assert Blog.recents(user).include?(obj)
    
    # user only, should not be recent.
    obj.set_privacy_level! 1
    assert_equal obj.privacy_level.privacy_level_type_id, 1
    assert_not Blog.recents(user).include?(obj)
  end
  
end
