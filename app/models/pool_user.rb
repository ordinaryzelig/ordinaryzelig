=begin
a user's participation in a season tournament.
=end

class PoolUser < ActiveRecord::Base
  
  belongs_to :season
  belongs_to :user
  has_many :pics
  
  attr_reader :points
  attr_reader :num_correct_pics
  
  # return PoolUser object of master user for given season.
  def PoolUser::master(season_id)
    User::master.season_pool_users(season_id)[0]
  end
  
  def PoolUser::standings_sort_proc
    Proc.new do |a, b|
      if a.points == b.points
        if a.num_correct_pics == b.num_correct_pics
          a.user.display_name.downcase <=> b.user.display_name.downcase
        else
          a.num_correct_pics <=> b.num_correct_pics
        end
      else
        b.points <=> a.points
      end
    end
  end
  
  # calculate total points earned by this PoolUser.
  def calculate_points(master_pics = nil, scoring_system = nil)
    master_pics ||= master_pics
    @points = 0
    correct_pics(master_pics).each do |pic|
      @points += pic.point_worth(scoring_system)
    end
    @points
  end
  
  # pics that are the same as other master pics passed.
  def correct_pics(master_pics = nil)
    master_pics ||= self.master_pics
    correct = []
    self.pics.each do |pic|
      correct << pic if pic.bid && master_pics.detect{|p| pic.game_id == p.game_id}.bid_id == pic.bid_id
    end
    @num_correct_pics = correct.size
    correct
  end
  
  def bracket_complete?
    !self.pics.empty? && self.pics.reject{|pic| pic.bid_id}.size == 0
  end
  
  def pic_for_game(game_id)
    pics.detect { |pic| game_id == pic.game_id }
  end
  
  def pics_left(games_undecided = nil)
    pics_left = []
    games_undecided ||= Game.undecided(season_id)
    games_undecided.each do |game|
      pic = game.pic(id)
      pics_left << pic if pic.still_alive?
    end
    pics_left
  end
  
  def points_left(games_undecided = nil, scoring_system = nil)
    points_left = 0
    games_undecided ||= Game.undecided(season_id)
    pics_left(games_undecided).each do |pic|
      points_left += pic.point_worth(scoring_system)
    end
    points_left
  end
  
  def can_beat?(other_pool_users, unique_pics = nil)
    unique_points = unique_points(other_pool_users, unique_pics)
    can_beat = true
    master_pics = self.master_pics
    calculate_points(master_pics)
    current_points = points
    other_pool_users.each do |pool_user|
      pool_user.calculate_points(master_pics)
      can_beat = false if pool_user.points > unique_points + current_points
    end
    can_beat
  end
  
  def unique_points(other_pool_users, unique_pics = nil, scoring_system = nil)
    unique_points = 0
    unique_pics ||= unique_pics(other_pool_users)
    unique_pics.each { |pic| unique_points += pic.point_worth(scoring_system) }
    unique_points
  end
  
  def unique_pics(other_pool_users)
    games_undecided = Game.undecided(season_id)
    uniques = []
    games_undecided.each do |game|
      my_pic = game.pic(id)
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
      if pic_for_game(pic.game_id).bid_id == pic.bid_id
        @points += pic.point_worth(scoring_system)
        @num_correct_pics += 1
      end
    end
  end
  
  def master_pics
    PoolUser::master(season_id).pics
  end
  
end