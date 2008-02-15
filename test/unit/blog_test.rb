require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < Test::Unit::TestCase
  
  fixtures :blogs, :users
  
  ATTRIBUTES = {:title => 'i killed heath ledger',
                :body => 'just watched brokeback mountain and dark knight looks badass.',
                :user_id => 2,
                :created_at => Time.now}
  
  def test_create
    # smooth.
    b = new_with_default_attributes!
    assert_not b.new_record?
    
    # test accessible.
    assert ATTRIBUTES[:user_id]
    assert ATTRIBUTES[:created_at]
    b = Blog.new(ATTRIBUTES)
    assert_nil_and_assign b, :user_id, ATTRIBUTES[:user_id]
    b.user_id = ATTRIBUTES[:user_id]
    assert b.save
  end
  
  test_created_at
  
  def test_summary
    b = new_with_default_attributes!
    assert ATTRIBUTES[:body].size > 50
    assert_equal b.summarize_what, b.body[0..50]
    assert_equal b.summarize_title, b.title
    assert_equal b.summarize_when, b.created_at
    assert_equal b.summarize_who, b.user
  end
  
  def test_syndication
    b = new_with_default_attributes!
    assert_equal b.syndicate_title, "Blog: #{b.title}"
    assert_equal b.syndicate_link, {:controller => 'blog', :action => :show, :id => b.id}
    assert_equal b.syndicate_description, b.body
    assert_equal b.syndicate_pubdate, b.created_at
    assert_equal b.syndicate_guid, "Blog_#{b.id}"
    assert_equal b.syndicate_author, b.user
  end
  
  def test_preview
    b = new_with_default_attributes!
    assert_equal b.preview, b.body
  end
  
  def test_mark_as_read
    b = new_with_default_attributes!
    user = users(:Surly_Stuka)
    assert Blog.find_all_read_by_user(user).empty?
    b.mark_as_read user
    assert_not Blog.find_all_read_by_user(user).empty?
  end
  
  def test_privacy_creation
    b = new_with_default_attributes!
    assert_not_nil b.privacy_level
  end
  
  # ===============================
  # helpers.
  
  def new_with_default_attributes
    b = Blog.new(ATTRIBUTES)
    b.user_id = ATTRIBUTES[:user_id]
    b
  end
  
  def new_with_default_attributes!
    b = new_with_default_attributes
    assert b.save
    b
  end
  
end
