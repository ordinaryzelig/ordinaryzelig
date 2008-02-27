require File.dirname(__FILE__) + '/../test_helper'

class GameTest < Test::Unit::TestCase
  
  fixtures :games
  
  defaults({:season_id => 1,
            :parent_id => nil,
            :round_id => 1,
            :region_id => 1})
  
  # more tests needed.
  
end
