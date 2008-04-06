require File.dirname(__FILE__) + '/../test_helper'

class SeasonTest < Test::Unit::TestCase
  
  march_madness_fixtures
  
  defaults({:tournament_starts_at => 1.year.from_now,
            :buy_in => 10,
            :max_num_brackets => 1})
  
  def test_bracket_size
    assert_equal test_new_with_default_attributes.games.size, 63
  end
  
  def test_master_pool_user
    season = test_new_with_default_attributes
    assert_not_nil season.pool_users.detect { |pu| User.master_id == pu.user_id }
  end
  
  def test_pics_assigned
    season = test_new_with_default_attributes
    season.games.each { |game| assert_not_nil game.pics.master }
  end
  
  def test_game_structure
    season = seasons(:_2007)
    assert has_x_descendants(season.regions.first.championship_game, 5)
    season = test_new_with_default_attributes
    assert has_x_descendants(season.regions.first.championship_game, 5)
  end
  
  def test_games_undecided
    season = Season.find(:first)
    assert season.games.undecided.empty?
    pic = season.games.first.pics.master
    pic.bid_id = nil
    pic.save!
    assert_not season.games.undecided.empty?
  end
  
  def test_creates_regions
    season = test_new_with_default_attributes
    assert_equal 5, season.regions.size
    assert_equal 4, season.regions.non_final_4.size
  end
  
  def test_bids
    season = test_new_with_default_attributes
    bids = season.games.bids
    assert_equal 64, bids.size
    bids.each { |bid| assert_not_nil bid }
  end
  
  def test_pool_users_by_rank
    season = seasons :_2007
    compare_ranks season.pool_users.by_rank, season
  end
  
  def test_pool_user_master
    season = seasons :_2007
    assert_equal PoolUser.find_by_user_id_and_season_id(User.master, season.id).id, season.pool_users.master.id
  end
  
  def test_pool_users_non_admin
    season = Season.find :first
    assert_equal season.pool_users.non_admin.size, season.pool_users.size - 1
  end
  
  # should help make sure ranking works with ties.
  def test_pre_season_ranks
    season = seasons :_2007
    master = season.pool_users.master
    pool_users = season.pool_users
    pool_users.each do |pool_user|
      pool_user.pics.each do |pic|
        pic.update_attribute(:bid_id, nil)
      end
    end
    pool_users.map(&:reload).each do |pool_user|
      assert_not pool_user.bracket_complete?
    end
    season.pool_users.by_rank(master.pics).each { |pool_user, rank| assert_equal 1, rank }
  end
  
  def test_regions_final_4
    season = Season.find(:first)
    assert_nil season.regions.final_4.championship_game.parent
  end
  
  # =================================================
  # helpers.
  
  # recursively check to see if there are the expected number of descendants for passed game.
  def has_x_descendants(game, descendants_left)
    if 0 == descendants_left
      game.children.empty?
    else
      has_x_descendants(game.children.first, descendants_left - 1) && has_x_descendants(game.children.last, descendants_left - 1)
    end
  end
  
  def compare_ranks(pool_users_with_ranks, season)
    assert pool_users_with_ranks.size > 0
    assert_equal pool_users_with_ranks.size, season.pool_users.size - 1
    pool_users_with_ranks.each do |pool_user, rank|
      if @previous_points
        assert pool_user.points <= @previous_points
        assert rank >= @previous_rank
      end
      @previous_points, @previous_rank = pool_user.points, rank
    end
  end
  
end
