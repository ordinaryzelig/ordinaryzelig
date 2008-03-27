require File.dirname(__FILE__) + '/../test_helper'

class MovieRatingTest < Test::Unit::TestCase
  
  fixtures :movie_ratings, :movies, :movie_rating_types, :movie_rating_options
  
  defaults({:movie_id => 1,
            :movie_rating_type_id => 1,
            :rating => 3,
            :summary => 'not bad, not at all bad',
            :explanation => 'it was aight. i mean, she has a neat voice but she has a wierd look',
            :user_id => 2},
           [:rating, :summary, :explanation])
  test_created_at
  test_mark_as_read
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
