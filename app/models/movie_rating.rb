class MovieRating < ActiveRecord::Base
  
  def self.container
    MovieRating.find(:all, :order => :id).map { |rating| ["#{rating.id} - #{rating.description}", rating.id] }
  end
  
  def to_s
    "#{id} out of 5 (#{description})"
  end
  
end
