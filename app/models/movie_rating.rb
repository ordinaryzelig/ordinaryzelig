class MovieRating < ActiveRecord::Base
  
  include ActionView::Helpers::TagHelper
  
  belongs_to :movie
  belongs_to :rating_type, :class_name => "MovieRatingType", :foreign_key => "movie_rating_type_id", :include => :rating_options
  belongs_to :user
  validates_presence_of :movie_id, :movie_rating_type_id, :rating, :user_id, :created_at
  validates_uniqueness_of :movie_id, :scope => [:movie_rating_type_id, :user_id], :message => " already rated for this rating type."
  nil_if_blank
  
  can_be_summarized_by :title => proc { "#{rating_type.name}: #{self}" },
                       :url => proc { {:controller => "movie", :action => "rating", :id => self.id} },
                       :what => :summary,
                       :max => 100,
                       :who => :user,
                       :when => :created_at,
                       :name => proc { movie.title }
  can_be_syndicated_by :title => proc {"#{movie}: #{rating_type} rating" },
                       :link => proc { {:controller => 'movie', :action => 'rating', :id => id} },
                       :description => proc { [summary, explanation].compact.inject(content_tag(:p, to_s)) { |str, element| "#{str}\n#{content_tag(:p, element)}" } }
  has_recency
  has_nested_comments
  preview_using :explanation
  can_be_marked_as_read
  is_entity_type
  
  attr_accessible :rating, :summary, :explanation
  
  def before_validation_on_create
    self.created_at = Time.now.localtime if self.created_at.nil? || new_record?
  end
    
  def rating_option
    rating_type.rating_options.detect { |option| option.value == rating }
  end
  
  def to_s
    "#{rating} (#{rating_option.description})"
  end
  
end
