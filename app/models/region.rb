class Region < ActiveRecord::Base
  
  belongs_to :season
  has_many :games
  
  def self.new_season
    regions = []
    # distribute bids into regions.
    # final four region.
    regions[0] = Region.new(:order_num => 1, :name => "final four")
    1.upto(4) {|i| regions[i] = Region.new(:order_num => i + 1)}
    regions
  end
  
  def championship_game
    Season.cached[self.season.tournament_year].root_game.children.flatten.detect { |game| id == game.region_id }
  end
  
  def self.container(season_id)
    find(:all,
         :conditions => {:season_id => season_id},
         :order => :order_num).map { |region| [region.name, region.order_num] }
  end
  
end
