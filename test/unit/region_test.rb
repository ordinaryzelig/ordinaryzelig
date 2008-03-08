require File.dirname(__FILE__) + '/../test_helper'

class RegionTest < Test::Unit::TestCase
  
  march_madness_fixtures
  
  def test_championship_game
    Region.find(:all).each do |region|
      championship_game = region.championship_game
      assert championship_game
      if championship_game.parent
        assert_not_equal championship_game.region, championship_game.parent.region
        championship_game.children.each { |game| assert_equal championship_game.region, game.region }
      else
        assert_equal championship_game, Season::CACHED[region.season.year].root_game
      end
    end
  end
  
end
