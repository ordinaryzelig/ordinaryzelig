class Movie < ActiveRecord::Base
  
  has_many :reviews, :class_name => "MovieReview"
  validates_presence_of :title
  validates_uniqueness_of :title
  
  can_be_summarized_by :title => :title, :what => proc { pluralize(reviews.size, "review") }, :who => nil
  
  def before_save
    self.imdb_id = nil if self.imdb_id.blank?
  end
  
  def self.by_latest_reviews
    movies = find(:all, :include => :reviews, :order => "created_at desc")
    movies.reject { |movie| movie.reviews.empty? }
  end
  
  def friend_reviews(user)
    @friend_reviews ||= reviews.select { |review| user.considers_friend?(review.user) } || []
  end
  
  # average rating for this movie.
  # if user passed, count only ratings from friends' reviews.
  def average_rating(user = nil)
    total = 0
    countable_reviews = user.nil? ? reviews : friend_reviews(user)
    countable_reviews.each do |review|
      total += review.rating.id
    end
    (0.0 + total) / countable_reviews.size
  end
  
end
