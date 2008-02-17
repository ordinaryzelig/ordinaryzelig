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
  test_privacy_level
  test_recency
  test_summaries :what => proc { |obj| obj.body[0..obj.summarize_max] },
                 :title => proc { |obj| obj.title },
                 :when => proc { |obj| obj.created_at },
                 :who => proc { |obj| obj.user },
                 :max => proc { 50 },
                 :url => proc { |obj| {:controller => 'blog', :action => 'show', :id => obj.id} }
  
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
  
end
