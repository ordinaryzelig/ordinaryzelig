class Region < ActiveRecord::Base
  
  belongs_to :season
  has_many :games, :order => :id do
    def in_first_round
      self.select { |game| 6 == game.round_id }
    end
  end
  
  validates_presence_of :name, :if => proc { |region| !region.new_record? }
  
  has_finder :non_final_4, :conditions => 'order_num != 1'
  
  def championship_game(game = self.season.root_game)
    return game if id == game.region_id
    game.children.map { |g| championship_game g }.compact.first
  end
  
  def self.container(season_id)
    find(:all,
         :conditions => {:season_id => season_id},
         :order => :order_num).map { |region| [region.name, region.order_num] }
  end
  
  def to_s
    name
  end
  
  def is_final_4?
    self == season.regions.final_4
  end
  
end
