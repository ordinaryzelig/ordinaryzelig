class Team < ActiveRecord::Base
  
  has_many :bids
  validates_presence_of :name
  
  # return array for select input selectables.
  def self.container
    Team.find(:all).collect { |team| [team.name, team.id] }.sort
  end
  
end
