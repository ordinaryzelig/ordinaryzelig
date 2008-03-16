class PoolUser < ActiveRecord::Base
  
  belongs_to :season
  belongs_to :user, :extend => User::AssociationMethods
  has_many :pics do
    include Pic::AssociationMethods
    def for_game(game)
      detect { |pic| game.id == pic.game_id }
    end
    # don't have to pass master_pics everytime because results get cached anyway.
    def correct(master_pics = nil)
      @correct_pics ||= self.select do |pic|
        pic.bid_id && master_pics.detect { |p| pic.game_id == p.game_id }.bid_id == pic.bid_id
      end
    end
  end
  
  before_validation { |pool_user| pool_user.bracket_num ||= 1 }
  validates_presence_of :bracket_num
  validates_uniqueness_of :bracket_num, :scope => [:user_id, :season_id]
  after_create do |pool_user|
    # create pics.
    games = Game.find(:all, :conditions => ["season_id = ?", pool_user.season_id])
    games.each { |game| Pic.new(:pool_user_id => pool_user.id, :game => game).save }
    # create account if needed.
    pool_user.user.accounts.create(:season_id => pool_user.season_id) unless pool_user.user.accounts.for_season(pool_user.season)
  end
  
  attr_reader :points
  
  scope_out :non_admin, :conditions => ['display_name not in (?)', ['master bracket', 'admin']], :include => :user
  
  # return PoolUser object of master user for given season.
  def self.master(season)
    User.master.pool_users.for_season(season).first
  end
  
  def self.standings_sort_proc
    proc do |a, b|
      unless a.points == b.points
        b.points <=> a.points
      else
        unless a.pics.correct.size == b.pics.correct.size
          a.pics.correct.size <=> b.pics.correct.size
        else
          a.user.display_name.downcase <=> b.user.display_name.downcase
        end
      end
    end
  end
  
  # calculate total points earned by this PoolUser.
  def calculate_points(master_pics, scoring_system = ScoringSystems.default)
    @points = 0
    pics.correct(master_pics).each do |pic|
      @points += pic.point_worth(scoring_system)
    end
    @points
  end
  
  def bracket_complete?
    !self.pics.empty? && self.pics.find_incomplete(:all).empty?
  end
  
  def pics_left(games_undecided = nil)
    games_undecided ||= season.games.undecided
    @pics_left = pics.select do |pic|
      pic.still_alive? && games_undecided.include?(pic.game)
    end
  end
  
  def points_left(games_undecided = season.games.undecided, scoring_system = ScoringSystems.default)
    points_left = 0
    pics.left(games_undecided).each do |pic|
      points_left += pic.point_worth(scoring_system)
    end
    points_left
  end
  
  def unique_points(other_pool_users, unique_pics = nil, scoring_system = ScoringSystems.default)
    unique_points = 0
    unique_pics ||= unique_pics(other_pool_users)
    unique_pics.each { |pic| unique_points += pic.point_worth(scoring_system) }
    unique_points
  end
  
  def unique_pics(other_pool_users)
    games_undecided = season.games.undecided
    uniques = []
    games_undecided.each do |game|
      my_pic = pics.for_game game
      if my_pic.still_alive?
        unique = true
        # iterate through other_pool_users and undecided pics.
        # if any other_pool_users has same pic, it's not unique.
        other_pool_users.each do |other|
          game.pics.each do |pic|
            unique = false if pic.pool_user_id == other.id && pic.bid_id == my_pic.bid_id
          end
        end
        uniques << my_pic if unique
      end
    end
    uniques
  end
  
  def simulate(winning_pics, scoring_system = nil)
    winning_pics.each do |pic|
      if pics.for_game(pic.game).bid_id == pic.bid_id
        @points += pic.point_worth(scoring_system)
      end
    end
  end
  
end
