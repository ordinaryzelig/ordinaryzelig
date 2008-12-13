require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase
  
  fixtures :comments, :comment_groups, :blogs
  defaults({:comment => "Hey don't underestimate the power of hugs. I can't count how many times I've given someone a hug and it's turned into dirty, wet and sticky sex. All the time in fact. You think it's innocent but oh no! When you wrap you're arms around someone in friendship it's just like wrapping a bow around Satan's little present of sin. That's why I support banning the hug and integrating oral sex as the new hey how are ya. It's reverse psychology dude, the kids will rebel and presto a new Victorian era. Thank you very much.",
            :user_id => Fixtures.identify(:ten_cent),
            :entity_type => 'Blog',
            :entity_id => Fixtures.identify(:public)},
           [:comment, :entity_type, :entity_id])
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
