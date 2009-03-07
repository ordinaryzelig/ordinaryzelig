require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase
  
  fixtures FIXTURES[:user]
  fixtures :comments, :comment_groups, :blogs
  
  defaults [:comment, :entity_type, :entity_id]
  
  can_be_marked_as_read_test_suite
  recency_test_suite
  test_summaries :what => proc { |obj| obj.comment[0..50] },
                 :title => proc { |obj| "#{obj.entity.class}: #{obj.entity.summarize_title}" },
                 :url => proc { |obj| obj.entity.summarize_url },
                 :max => proc { 50 },
                 :who => proc { |obj| obj.user },
                 :when => proc { |obj| obj.created_at }
  test_syndications :title => proc { |obj| "comment for #{obj.entity.class}: #{obj.entity.summarize_title}" },
                    :link => proc { |obj| obj.entity.syndicate_link },
                    :description => proc { |obj| obj.comment },
                    :pubdate => proc { |obj| obj.created_at },
                    :guid => proc { |obj| "Comment_#{obj.id}" },
                    :author => proc { |obj| obj.user }
  
end
