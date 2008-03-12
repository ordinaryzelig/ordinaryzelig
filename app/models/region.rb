class Region < ActiveRecord::Base
  
  belongs_to :season
  has_many :games do
    def in_first_round
      self.select { |game| 6 == game.round_id }
    end
  end
  
  validates_presence_of :name, :if => proc { |region| !region.new_record? }
  
  scope_out :non_final_4, :conditions => 'order_num != 1'
  
  def championship_game(game = Season::CACHED[self.season.year].root_game)
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
  
end
