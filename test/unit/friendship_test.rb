require File.dirname(__FILE__) + '/../test_helper'

class FriendshipTest < ActiveSupport::TestCase
  
  fixtures FIXTURES[:user]
  
  defaults [:user_id, :friend_id]
  
  test_created_at
  can_be_marked_as_read_test_suite
  recency_test_suite
  test_summaries :title => proc { |obj| "#{obj.user.first_last_display} added you as a friend." },
                 :when => proc { |obj| obj.created_at },
                 :who => proc { nil },
                 :max => proc { 50 },
                 :url => proc { |obj| {:controller => 'user', :action => 'profile', :id => obj.user_id} }
  test_syndications :title => proc { |obj| "#{obj.user.first_last} added you as a friend."},
                    :link => proc { |obj| {:controller => 'user', :action => 'profile', :id => obj.user.id} },
                    :description => proc { nil },
                    :pubdate => proc { |obj| obj.created_at },
                    :guid => proc { |obj| "Friendship_#{obj.id}" },
                    :author => proc { |obj| obj.user }
  
end
