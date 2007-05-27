=begin
region in a season.
=end

class Region < ActiveRecord::Base
  
  #belongs_to :season
  has_many :games
  
  # create and return new season's regions.
  def Region::new_season
    regions = []
    # distribute bids into regions.
    # final four region.
    regions[0] = Region.new(:order_num => 1, :name => "final four")
    1.upto(4) {|i| regions[i] = Region.new(:order_num => i + 1)}
    regions
  end
  
  def championship_game
    self.games.detect do |game|
      if !game.ancestors.empty?
        game.ancestors.size == 2
      else
        true
      end
    end
  end
  
  def Region::container(season_id)
    regions = Region.find(:all, :conditions => ["season_id = ?", season_id], :order => :order_num).collect{|region| [region.name, region.order_num]}
  end
  
end
