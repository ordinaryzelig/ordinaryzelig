require File.dirname(__FILE__) + '/../test_helper'

class FriendshipTest < Test::Unit::TestCase
  
  fixtures :friendships
  
  defaults({:user_id => 4,
            :friend_id => 2},
           [:user_id, :friend_id])
  test_created_at
  test_mark_as_read
  test_recency
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
