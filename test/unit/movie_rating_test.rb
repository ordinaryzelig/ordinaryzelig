require File.dirname(__FILE__) + '/../test_helper'

class MovieRatingTest < ActiveSupport::TestCase
  
  fixtures FIXTURES[:user]
  fixtures FIXTURES[:movie]
  
  defaults [:rating, :summary, :explanation]
  
  test_created_at
  can_be_marked_as_read_test_suite
  recency_test_suite
  test_summaries :what => proc { |obj| (obj.summary || obj.explanation)[0..obj.summarize_max] },
                 :who => proc { |obj| obj.user },
                 :when => proc { |obj| obj.created_at },
                 :name => proc { |obj| "#{obj.movie}" },
                 :title => proc { |obj| "#{obj.rating_type}: #{obj}" },
                 :max => proc { 100 },
                 :url => proc { |obj| {:controller => 'movie', :action => 'rating', :id => obj.id} }
  test_syndications :title => proc { |obj| "#{obj.movie}: #{obj.rating_type} rating"},
                    :link => proc { |obj| {:controller => 'movie', :action => 'rating', :id => obj.id} },
                    :description => proc { |obj| "<p>#{obj}</p>\n<p>#{obj.summary}</p>\n<p>#{obj.explanation}</p>" },
                    :pubdate => proc { |obj| obj.created_at },
                    :guid => proc { |obj| "MovieRating_#{obj.id}" },
                    :author => proc { |obj| obj.user }
  
end
