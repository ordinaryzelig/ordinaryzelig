class Movie < ActiveRecord::Base
  
  has_many :ratings, :class_name => "MovieRating"
  has_many :reviews, :class_name => "MovieRating", :conditions => "movie_rating_type_id = 1", :include => :rating_type
  validates_presence_of :title
  validates_uniqueness_of :title
  
  can_be_summarized_by :title => :title, :what => proc { pluralize(ratings.size, "rating") }, :who => nil
  
  def before_save
    self.imdb_id = nil if self.imdb_id.blank?
  end
  
  def self.by_latest_ratings
    movies = find(:all, :include => :ratings, :order => "created_at desc").reject { |movie| movie.ratings.empty? }
  end
  
  def average_rating(&block)
    total = 0
    countable_ratings = block ? ratings.select(&block) : ratings
    countable_ratings.each do |rating|
      total += rating.rating
    end
    average_rating = (0.0 + total) / countable_ratings.size
    average_rating > 0 ? average_rating : 0
  end
  
end
