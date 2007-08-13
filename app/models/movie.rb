class Movie < ActiveRecord::Base
  
  has_many :reviews, :class_name => "MovieReview"
  validates_presence_of :title
  validates_uniqueness_of :title
  
  can_be_summarized_by :title => :title, :what => proc { pluralize(reviews.size, "review") }
  
  def self.by_latest_reviews
    movies = find(:all, :include => :reviews, :order => "created_at desc")
    movies.reject { |movie| movie.reviews.empty? }
  end
  
end
