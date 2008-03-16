require File.dirname(__FILE__) + '/../test_helper'

class RegionTest < Test::Unit::TestCase
  
  march_madness_fixtures
  
  def test_championship_game
    Region.find(:all).each do |region|
      championship_game = region.championship_game
      assert championship_game
      championship_game.is_championship_game?
      if championship_game.parent
        assert_not_equal championship_game.region, championship_game.parent.region
        championship_game.children.each { |game| assert_equal championship_game.region, game.region }
      else
        assert_equal championship_game, championship_game.season.root_game
      end
    end
  end
  
  def test_games_in_first_round
    region = Region.find_non_final_4(:first)
    games = region.games.in_first_round
    assert_equal 8, games.size
  end
  
end
