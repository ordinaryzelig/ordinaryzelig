=begin
a user's participation in a season tournament.
=end

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
  
  attr_reader :points
  
  # return PoolUser object of master user for given season.
  def self.master(season)
    User.find_master(:first).pool_users.for_season(season).first
  end
  
  def self.standings_sort_proc
    Proc.new do |a, b|
      if a.points == b.points
        if a.pics.correct.size == b.pics.correct.size
          a.user.display_name.downcase <=> b.user.display_name.downcase
        else
          a.pics.correct.size <=> b.pics.correct.size
        end
      else
        b.points <=> a.points
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
    return @pics_left if @pics_left
    games_undecided ||= Game.undecided(season)
    @pics_left = pics.select do |pic|
      pic.still_alive? && games_undecided.include?(pic.game)
    end
  end
  
  def points_left(games_undecided = Game.undecided(season), scoring_system = ScoringSystems.default)
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
    games_undecided = Game.undecided(season)
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
