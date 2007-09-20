=begin
season tournament.
=end

class Season < ActiveRecord::Base
  
  has_many :regions, :order => "order_num"
  has_many :games
  has_many :pool_users
  
  # create new season.
  def Season::new_season
    season = Season.new
    # add new regions.
    season.regions = Region::new_season
    season.save
    # new PoolUser.
    pool_user = PoolUser.new(:user_id => User::master, :season => season, :bracket_num => 1)
    # new bracket of games.
    Game::new_season(season)
    # create new pics for each game.
    games = season.games
    games.each do |game|
      game.pics << Pic.new(:pool_user => pool_user)
      game.save
    end
    # new bids.
    bids = Bid::new_season
    # assign bids to games.
    season.regions.reject{|region| 1 == region.order_num}.each_with_index do |region, i|
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
  
  def Season::current
    Season.find(:first, :conditions => ["is_current = ?", 1])
  end
  
  def Season::container
    Season.find(:all, :order => "tournament_year").collect{|season| [season.tournament_year, season.id]}
  end
  
  def self.latest
    Season.find(:all, :order => :tournament_year).last
  end
  
end
