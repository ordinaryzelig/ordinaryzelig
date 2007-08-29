class MovieRatingOption < ActiveRecord::Base
  
  validates_presence_of :movie_rating_type_id, :description, :value
  
end
