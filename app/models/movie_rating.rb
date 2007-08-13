class MovieRating < ActiveRecord::Base
  
    def self.container
      MovieRating.find(:all, :order => :id).map { |rating| ["#{rating.id} - #{rating.description}", rating.id] }
    end
  
end
