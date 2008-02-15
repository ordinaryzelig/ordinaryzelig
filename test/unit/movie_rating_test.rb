require File.dirname(__FILE__) + '/../test_helper'

class MovieRatingTest < Test::Unit::TestCase
  
  fixtures :movie_ratings, :movies, :movie_rating_types, :movie_rating_options
  
  ATTRIBUTES = {:movie_id => 1,
                :movie_rating_type_id => 1,
                :rating => 3,
                :summary => 'not bad, not at all bad',
                :explanation => 'it was aight. i mean, she has a neat voice but she has a wierd look',
                :user_id => 2,
                :created_at => Time.now}
  
  def test_creation
    # smooth.
    m = new_with_default_attributes!
    assert_not m.new_record?
    m.destroy
    
    # test accessible.
    assert ATTRIBUTES[:user_id]
    assert ATTRIBUTES[:created_at]
    m = MovieRating.new(ATTRIBUTES)
    [:user_id, :movie_id, :movie_rating_type_id].each do |att|
      assert_nil_and_assign m, att, ATTRIBUTES[att]
    end
    assert m.save
  end
  
  test_created_at
  
  # ==================================
  # helpers.
  
  def new_with_default_attributes
    m = MovieRating.new(ATTRIBUTES)
    m.user_id = ATTRIBUTES[:user_id]
    m.movie_id = ATTRIBUTES[:movie_id]
    m.movie_rating_type_id = ATTRIBUTES[:movie_rating_type_id]
    m
  end
  
  def new_with_default_attributes!
    m = new_with_default_attributes
    m.valid?
    puts m.errors.full_messages
    assert m.save
    m
  end
  
end
