require File.dirname(__FILE__) + '/../test_helper'

class MovieRatingTest < Test::Unit::TestCase
  
  fixtures :movie_ratings, :movies, :movie_rating_types, :movie_rating_options
  
  defaults_for MovieRating,
               {:movie_id => 1,
                :movie_rating_type_id => 1,
                :rating => 3,
                :summary => 'not bad, not at all bad',
                :explanation => 'it was aight. i mean, she has a neat voice but she has a wierd look',
                :user_id => 2},
               [:rating, :summary, :explanation]
  test_created_at
  test_mark_as_read MovieRating
  test_recency
  test_summaries :what => proc { |obj| (obj.summary || obj.explanation)[0..obj.summarize_max] },
                 :who => proc { |obj| obj.user },
                 :when => proc { |obj| obj.created_at },
                 :name => proc { |obj| obj.movie.title },
                 :title => proc { |obj| "#{obj.rating_type}: #{obj}" },
                 :max => proc { 100 },
                 :url => proc { |obj| {:controller => 'movie', :action => 'rating', :id => obj.id} }
  
end
