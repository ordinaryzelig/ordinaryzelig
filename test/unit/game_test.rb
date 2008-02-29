require File.dirname(__FILE__) + '/../test_helper'

class GameTest < Test::Unit::TestCase
  
  fixtures :games, :pool_users
  
  defaults({:season_id => 1,
            :parent_id => nil,
            :round_id => 1,
            :region_id => 1})
  
end
