class MovieRatingOption < ActiveRecord::Base
  
  belongs_to :review_type, :class_name => "MovieRatingType", :foreign_key => "movie_review_type_id"
  validates_presence_of :movie_rating_type_id, :description, :value
  
end
