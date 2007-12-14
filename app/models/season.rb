class Season < ActiveRecord::Base
  
  has_many :regions, :order => "order_num"
  has_many :games
  has_many :pool_users
  
  validates_presence_of :tournament_year
  
  def self.new_season
    season = self.new
    # add new regions.
    season.regions = Region.new_season
    season.save
    # new PoolUser.
    pool_user = PoolUser.new(:user_id => User.master, :season => season, :bracket_num => 1)
    # new bracket of games.
    Game.new_season(season)
    # create new pics for each game.
    games = season.games
    games.each do |game|
      game.pics << Pic.new(:pool_user => pool_user)
      game.save
    end
    # new bids.
    bids = Bid.new_season
    # assign bids to games.
    season.regions.reject { |region| 1 == region.order_num }.each_with_index do |region, i|
      region.games.reject { |game| 6 != game.round_id }.each_with_index do |game, j|
        2.times do |k|
          bid = bids[i][j * 2 + k]
          bid.first_game_id = game.id
          bid.save
        end
      end
    end
    # update SEASONS cache.
    SEASONS[season.tournament_year] = find(season.id).load_games
    season
  end
  
  def self.container
    find(:all, :order => :tournament_year).map { |season| [season.tournament_year, season.id] }
  end
  
  def self.latest
    SEASONS[find(:first, :order => "tournament_year desc").tournament_year]
  end
  
  def root_game
    return @root_game if @root_game
    @root_game = Game.root_for_season self
    @root_game.load_children
    @root_game
  end
  
  def load_games
    root_game
    self
  end
  
  def self.cached
    return @cached_season if @cached_season && RAILS_ENV['ENV'] == 'production'
    @cached_season = Season.find(:all).inject({}) do |hash, season|
      hash[season.tournament_year] = season.load_games
      hash
    end
  end
  
end
