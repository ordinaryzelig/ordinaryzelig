require File.dirname(__FILE__) + '/../test_helper'

class GameTest < ActiveSupport::TestCase
  
  march_madness_fixtures
  
  defaults({:season_id => 1,
            :parent_id => nil,
            :round_id => 1,
            :region_id => 1})
  
  def test_master_pic
    game = Game.find :first
    assert game.season
    assert_equal game.pics.master, Pic.find(:first, :conditions => {:game_id => game.id, :pool_user_id => PoolUser.master(game.season)})
  end
  
  def test_child_with_pic
    game = seasons(:_2007).root_game
    pic = game.top.pics.first
    assert_equal game.child_with_pic(pic), game.top
  end
  
  def test_game_in_lineage_with_pic
    game = seasons(:_2007).root_game
    pic = game.top.pics.first
    assert_game_in_lineage_with_pic game, pic
  end
  
  def assert_game_in_lineage_with_pic(game, pic)
    unless game.children.empty?
      assert_equal game.game_in_lineage_with_pic(pic, game.round.number - 1), game.child_with_pic(pic)
      assert_game_in_lineage_with_pic game.child_with_pic(pic), pic
    end
  end
  
  def test_root_for_season
    Season.find(:all).each do |season|
      root_game = Game.root_for_season(season)
      assert_nil root_game.parent
      assert_equal root_game, root_game.root
    end
  end
  
  def test_declare_winner
    # test for championship game.
    season = Season.find(:first)
    game = season.root_game
    pool_user = PoolUser.master(season)
    pic = pool_user.pics.for_game(game)
    bid = pic.bid
    # erase bid for pic.
    pic.bid_id = nil
    assert_save! pic
    assert_not pool_user.bracket_complete?
    # declare winner for championship_game for master pool_user.
    game.declare_winner(bid, pool_user)
    assert pool_user.bracket_complete?
    assert_equal pool_user.pics.for_game(game).bid_id, bid.id
    
    # take champion, find their first game and declare the other winner.
    # then test that all all subsequent pics are changed.
    first_game = bid.first_game
    other_pics_affected = first_game.declare_winner first_game.first_round_bids.detect { |b| b != bid }, pool_user
    assert_equal first_game.ancestors.size, other_pics_affected.size
    other_pics_affected.each do |pic|
      assert_nil pic.bid_id
    end
  end
  
  def test_participating_bids
    game = games :george_mason_first_game
    pool_user = users(:master_bracket).pool_users.for_season(game.season).first
    assert game.children.empty?
    assert_participating_bids game.participating_bids(pool_user), ['george mason', 'michigan state']
    assert_participating_bids game.season.root_game.participating_bids(pool_user), ['florida', 'ucla']
  end
  
  def assert_participating_bids(bids, team_names)
    assert_equal 2, bids.size
    bids.each do |bid|
      assert team_names.include?(bid.team.name)
    end
  end
  
  def test_top_bottom
    parent = games(:george_mason_first_game).parent
    assert_equal 2, parent.children.size
    parent.children.each { |game| is_top_or_bottom? parent, game }
  end
  
  def is_top_or_bottom?(parent, child)
    direction = child.top? ? :top : :bottom
    assert_equal child.id, parent.send(direction).id
  end
  
  def test_left_or_right
    parent = games(:george_mason_first_game).root
    assert_equal 2, parent.children.size
    assert_equal 0, parent.ancestors.size
    assert_equal 'left', parent.top.left_or_right
    assert_equal 'right', parent.bottom.left_or_right
    assert_equal nil, parent.left_or_right
  end
  
  def test_is_championship_game?
    season = seasons(:_2007)
    assert_equal 5, season.games.map { |game| game.is_championship_game? || nil }.compact.size
    season.regions.each do |region|
      game = region.championship_game
      assert game.is_championship_game?
      assert_equal game.parent ? 2 : 0, game.ancestors.size
    end
  end
  
end
