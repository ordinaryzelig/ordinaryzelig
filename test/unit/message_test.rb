require File.dirname(__FILE__) + '/../test_helper'

class MessageTest < ActiveSupport::TestCase
  
  fixtures :messages
  
  defaults({:body => "georgetown is going to win!  unc just doesn't have it this year.  florida hasn't been tested enough.  greg oden is injured.",
            :subject => 'g-town',
            :user_id => Fixtures.identify(:ten_cent)},
           [:subject, :body])
  can_be_marked_as_read_test_suite
  recency_test_suite
  test_summaries :what => proc { |obj| obj.body[0..100] },
                 :title => proc { |obj| obj.subject },
                 :url => proc { |obj| {:controller => 'message_board', :action => 'show', :id => obj.id} },
                 :max => proc { 100 },
                 :who => proc { |obj| obj.user },
                 :when => proc { |obj| obj.created_at }
  test_syndications :title => proc { |obj| obj.subject },
                    :link => proc { |obj| {:controller => 'message_board', :action => 'show', :id => obj.id} },
                    :description => proc { |obj| obj.body },
                    :pubdate => proc { |obj| obj.created_at },
                    :guid => proc { |obj| "Message_#{obj.id}" },
                    :author => proc { |obj| obj.user }
  
end
