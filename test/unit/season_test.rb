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
  
  def test_cached
    season = test_new_with_default_attributes
    season.destroy
    assert Season::CACHED[defaults[:tournament_starts_at].year].nil?, 'season was found in CACHED.'
    season = test_new_with_default_attributes
    assert Season::CACHED[season.year], 'season was not found in CACHED.'
    assert_equal Season::CACHED[season.year].id, season.in_cache.id
  end
  
  # recursively check to see if there are the expected number of descendants for passed game.
  def has_x_descendants(game, descendants_left)
    if 0 == descendants_left
      game.children.empty?
    else
      has_x_descendants(game.children.first, descendants_left - 1) && has_x_descendants(game.children.last, descendants_left - 1)
    end
  end
  
  def test_games_undecided
    season = Season.find(:first)
    assert season.games.undecided.empty?
    pic = season.games.first.pics.master
    pic.bid_id = nil
    pic.save!
    assert_not season.games.undecided.empty?
  end
  
  def test_populate_cache
    Season.find(:all).each do |season|
      assert Season::CACHED.keys.include?(season.year)
    end
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
  
  def test_pool_users_sorted_by_points
    season = seasons :_2007
    master = season.pool_users.master
    assert_equal 63, master.pics.size
    pool_users = season.pool_users.sorted_by_points master.pics
    assert pool_users.size > 0
    assert_equal pool_users.size, season.pool_users.size - 1
  end
  
  def test_pool_user_master
    season = seasons :_2007
    assert_equal PoolUser.find_by_user_id_and_season_id(User.master, season.id).id, season.pool_users.master.id
  end
  
end
