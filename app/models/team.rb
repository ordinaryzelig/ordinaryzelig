=begin
university team.
=end

class Team < ActiveRecord::Base
  
  has_many :bids
  
  # return array for select input selectables.
  def Team::select_options
    Team.find(:all).collect { |team| [team.name, team.id] }.sort
  end
  
end
