require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < ActiveSupport::TestCase
  
  fixtures FIXTURES[:user]
  fixtures :blogs
  fixtures :friendships, :privacy_levels
  
  defaults [:title, :body]
  test_created_at
  can_be_marked_as_read_test_suite
  privacy_test_suite
  recency_test_suite
  test_summaries :what => proc { |obj| obj.body[0..obj.summarize_max] },
                 :title => proc { |obj| obj.title },
                 :when => proc { |obj| obj.created_at },
                 :who => proc { |obj| obj.user },
                 :max => proc { 50 },
                 :url => proc { |obj| {:controller => 'blog', :action => 'show', :id => obj.id} }
  test_syndications :title => proc { |obj| "Blog: #{obj.title}"},
                    :link => proc { |obj| {:controller => 'blog', :action => 'show', :id => obj.id} },
                    :description => proc { |obj| obj.body },
                    :pubdate => proc { |obj| obj.created_at },
                    :guid => proc { |obj| "Blog_#{obj.id}" },
                    :author => proc { |obj| obj.user }
  
  def test_preview
    b = test_new_with_default_attributes
    assert_equal b.preview, b.body
  end
  
end
