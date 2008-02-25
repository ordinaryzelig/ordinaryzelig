require File.dirname(__FILE__) + '/../test_helper'

class SeasonTest < Test::Unit::TestCase
  
  fixtures :seasons
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
    season.games.each { |game| assert_not_nil game.master_pic }
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
  end
  
  # recursively check to see if there are the expected number of descendants for passed game.
  def has_x_descendants(game, descendants_left)
    if 0 == descendants_left
      game.children.empty?
    else
      has_x_descendants(game.children.first, descendants_left - 1) && has_x_descendants(game.children.last, descendants_left - 1)
    end
  end
  
end
