class MovieReview < ActiveRecord::Base
  
  belongs_to :movie
  belongs_to :rating, :class_name => "MovieRating", :foreign_key => "movie_rating_id"
  belongs_to :user
  validates_presence_of :movie_id, :movie_rating_id, :created_at, :user_id
  validates_uniqueness_of :scope => :user_id
  
  def validate
    if !self.title.blank? || !self.review.blank?
      errors.add_on_blank(:title)
      errors.add_on_blank(:review)
    end
  end
  
  def before_save
    self.title = nil if self.title.blank?
    self.review = nil if self.review.blank?
  end
  
  can_be_summarized_by :title => proc { "#{rating} - #{title}" },
                       :url => proc { {:controller => "movie", :action => "review", :id => self.id} },
                       :what => :review,
                       :max => 100,
                       :who => :user,
                       :when => :created_at
  has_recency
  has_nested_comments
  
  def before_validation_on_create
    self.created_at = Time.now.localtime if self.created_at.nil? || new_record?
  end
  
end
