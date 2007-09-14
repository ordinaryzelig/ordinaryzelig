class MovieRatingType < ActiveRecord::Base
  
  has_many :rating_options, :class_name => "MovieRatingOption", :foreign_key => "movie_rating_type_id", :order => "value"
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def container
    rating_options.map { |option| ["#{option.value} - #{option.description}", option.value] }.sort { |a, b| a[1] <=> b[1] }
  end
  
  def to_s
    name
  end
  
end
