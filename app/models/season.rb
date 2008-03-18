class Season < ActiveRecord::Base
  
  has_many :regions, :order => "order_num" do
    include Region::AssociationMethods
    def final_4
      (self - non_final_4).first
    end
  end
  has_many :games, :order => "#{Game.table_name}.id" do
    def undecided
      find(:all,
           :conditions => ["pool_user_id = ? and " <<
                           "#{Bid.table_name}.id is null",
                           PoolUser.master(first.season)],
           :include => {:pics => [:pool_user, :bid]})
    end
    def bids
      Bid.find :all, :conditions => ['first_game_id in (?)', map(&:id)]
    end
  end
  has_many :pool_users do
    include PoolUser::AssociationMethods
    def by_rank(master_pics, scoring_system = ScoringSystems.default)
      return @pool_users_with_ranks if @pool_users_with_ranks
      pool_users = find_non_admin :all, :include => [{:pics => [:bid, {:game => :round}]}, :user]
      pool_users.each { |pool_user| pool_user.calculate_points(master_pics, scoring_system) }
      pool_users.sort! &PoolUser.standings_sort_proc
      ties = 0
      previous_points = nil
      previous_pics = nil
      rank = 0
      counter = 0
      @pool_users_with_ranks = pool_users.map do |pool_user|
        if previous_points == pool_user.points && previous_pics == pool_user.pics.correct.size
          ties += 1
        else
          ties = 0
        end
        counter += 1
        rank = counter - ties
        previous_points = pool_user.points
        previous_pics = pool_user.pics.correct.size
        [pool_user, rank]
      end
    end
    def master
      detect { |pool_user| User.master_id == pool_user.user_id }
    end
  end
  
  after_create do |season|
    # add regions.
    1.upto(5) { |i| season.regions.create(:order_num => i) }
    season.regions.first.update_attribute 'name', 'final four'
    
    # add master pool user.
    pool_user = PoolUser.create!(:user_id => User.master, :season_id => season.id)
    
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
    season.regions.non_final_4.each do |region|
      seeds = Bid::SEEDS.dup
      region.games.in_first_round.each do |game|
        2.times { |j| Bid.create! :first_game_id => game.id, :seed => seeds.shift }
      end
    end
  end
  
  validates_presence_of :tournament_starts_at, :max_num_brackets, :buy_in
  
  def self.container
    find(:all, :order => :tournament_starts_at).map { |season| [season.year, season.id] }
  end
  
  def self.latest
    find(:first, :order => "tournament_starts_at desc")
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
  
  def tournament_has_started?
    tournament_starts_at < Time.now
  end
  
  def year
    self.tournament_starts_at.year
  end
  
  def self.find_by_year(year)
    
  end
  
end
