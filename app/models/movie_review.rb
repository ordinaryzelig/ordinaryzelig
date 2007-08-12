class MovieReview < ActiveRecord::Base
  
  belongs_to :movie
  belongs_to :rating, :class_name => "MovieRating", :foreign_key => "movie_rating_id"
  belongs_to :user
  validates_presence_of :movie_id, :review, :movie_rating_id, :created_at, :user_id
  validates_uniqueness_of :movie_rating_id, :scope => :user_id
  
  can_be_summarized_by :title => proc { movie.title }, :what => proc { "#{movie.reviews.size} reviews" }
  
  def before_validation_on_create
    self.created_at = Time.now.localtime if self.created_at.nil? || new_record?
  end
  
end
