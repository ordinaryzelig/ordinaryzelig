class Season < ActiveRecord::Base
  
  has_many :regions, :order => "order_num" do
    def non_final_four
      reject { |region| 1 == region.order_num }
    end
  end
  has_many :games
  has_many :pool_users
  after_create do |season|
    # add regions.
    1.upto(5) { |i| season.regions << Region.new(:order_num => i) }
    season.regions.first.update_attribute 'name', 'final four'
    
    # add master pool user.
    pool_user = PoolUser.new(:user_id => User.master, :season_id => season.id)
    
    # create bracket of games.
    Game.new_season(season)
    
    # add master pics.
    games = season.games
    games.each do |game|
      game.pics << Pic.new(:pool_user => pool_user)
      game.save
    end
    
    # new bids.
    bids = Bid.new_season
    
    # assign bids to games.
    season.regions.non_final_four.each_with_index do |region, region_index|
      region.games.in_first_round.each_with_index do |game, game_index|
        2.times do |k|
          bid = bids[region_index][j * 2 + game_index]
          bid.first_game_id = game.id
          bid.save
        end
      end
    end
    
    # update SEASONS cache.
    CACHED[season.year] = find(season.id).load_games
  end
  after_destroy do |season|
    CACHED.delete season.year
  end
  
  def self.container
    find(:all, :order => :tournament_starts_at).map { |season| [season.year, season.id] }
  end
  
  def self.latest
    CACHED[find(:first, :order => "tournament_starts_at desc").year]
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
  
  def is_editable?
    Time.now < tournament_starts_at
  end
  
  def year
    self.tournament_starts_at.year
  end
  
  CACHED = Season.find(:all).inject({}) do |hash, season|
    hash[season.tournament_starts_at.year] = season.load_games
    hash
  end
  
end
