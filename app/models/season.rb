=begin
season tournament.
=end

class Season < ActiveRecord::Base
  
  has_many :regions, :order => "order_num"
  has_many :games
  has_many :pool_users
  
  def self.new_season
    season = self.new
    # add new regions.
    self.regions = Region::new_season
    self.save
    # new PoolUser.
    pool_user = PoolUser.new(:user_id => User.master, :season => season, :bracket_num => 1)
    # new bracket of games.
    Game.new_season(season)
    # create new pics for each game.
    games = self.games
    games.each do |game|
      game.pics << Pic.new(:pool_user => pool_user)
      game.save
    end
    # new bids.
    bids = Bid::new_season
    # assign bids to games.
    self.regions.reject{|region| 1 == region.order_num}.each_with_index do |region, i|
      region.games.reject{|game| 6 != game.round_id}.each_with_index do |game, j|
        2.times do |k|
          bid = bids[i][j * 2 + k]
          bid.first_game_id = game.id
          bid.save
        end
      end
    end
    season
  end
  
  def self.container
    find(:all, :order => :tournament_year).map { |season| [season.tournament_year, season.id] }
  end
  
  def self.latest
    find(:first, :order => "tournament_year desc")
  end
  
end
