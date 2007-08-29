class MovieRating < ActiveRecord::Base
  
  belongs_to :movie
  belongs_to :rating_type, :class_name => "MovieRatingType", :foreign_key => "movie_rating_type_id", :include => :rating_options
  belongs_to :user
  validates_presence_of :movie_id, :movie_rating_type_id, :rating, :user_id, :created_at
  
  can_be_summarized_by :title => proc { (summary ? "#{summary}: " : "") << rating_to_s },
                       :url => proc { {:controller => "movie", :action => "rating", :id => self.id} },
                       :what => :explanation,
                       :max => 100,
                       :who => :user,
                       :when => :created_at,
                       :type => proc { "#{rating_type.name} rating" }
  has_recency
  has_nested_comments
  preview_using :explanation
  
  def before_validation_on_create
    self.created_at = Time.now.localtime if self.created_at.nil? || new_record?
  end
    
  def rating_option
    rating_type.rating_options.detect { |option| option.value == rating }
  end
  
  def rating_to_s
    "#{rating} out of #{rating_type.rating_options.size} (#{rating_option.description})"
  end
  
end
