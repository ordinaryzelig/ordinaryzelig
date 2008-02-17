require File.dirname(__FILE__) + '/../test_helper'

class MessageTest < Test::Unit::TestCase
  
  fixtures :messages
  
  defaults({:body => "georgetown is going to win!  unc just doesn't have it this year.  florida hasn't been tested enough.  greg oden is injured.",
            :subject => 'g-town',
            :user_id => 32},
           [:subject, :body])
  test_mark_as_read
  test_recency
  test_summaries :what => proc { |obj| obj.body[0..100] },
                 :title => proc { |obj| obj.subject },
                 :url => proc { |obj| {:controller => 'message_board', :action => 'show', :id => obj.id} },
                 :max => proc { 100 },
                 :who => proc { |obj| obj.user }
  test_syndications :title => proc { |obj| obj.subject },
                    :link => proc { |obj| {:controller => 'message_board', :action => 'show', :id => obj.id} },
                    :description => proc { |obj| obj.body },
                    :pubdate => proc { |obj| obj.created_at },
                    :guid => proc { |obj| "Message_#{obj.id}" },
                    :author => proc { |obj| obj.user }
  
end
