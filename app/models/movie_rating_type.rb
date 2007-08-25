class MovieRatingType < ActiveRecord::Base
  
  has_many :rating_options, :class_name => "MovieRatingOption", :foreign_key => "movie_rating_type_id"
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def self.container
    MovieRating.find(:all, :order => :id).map { |rating| ["#{rating.id} - #{rating.description}", rating.id] }
  end
  
end
