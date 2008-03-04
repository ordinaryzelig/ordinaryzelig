require File.dirname(__FILE__) + '/../test_helper'

class GameTest < Test::Unit::TestCase
  
  fixtures :games, :pool_users, :seasons
  
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
    game = Season::CACHED[2007].root_game
    pic = game.top.pics.first
    assert_equal game.child_with_pic(pic), game.top
  end
  
  def test_game_in_lineage_with_pic
    game = Season::CACHED[2007].root_game
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
  
end
