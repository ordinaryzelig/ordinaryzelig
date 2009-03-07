class Bid < ActiveRecord::Base
  
  belongs_to :team
  belongs_to :first_game, :class_name => "Game", :foreign_key => "first_game_id"
  
  SEEDS = [1, 16, 8, 9, 5, 12, 4, 13, 6, 11, 3, 14, 7, 10, 2, 15].freeze
  
  # create 64 bids, 16 for each region.
  def self.new_season
    bids = []
    4.times do
      region_bids = []
      SEEDS.each { |seed| region_bids << Bid.new(:seed => seed) }
      bids << region_bids
    end
    bids
  end
  
  def to_s
    "#{seed} #{h(self.team.name)}"
  end
  
end
