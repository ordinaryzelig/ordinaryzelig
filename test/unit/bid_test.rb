require File.dirname(__FILE__) + '/../test_helper'

class BidTest < Test::Unit::TestCase
  
  fixtures :bids
  
  defaults({:team_id => 1,
            :seed => 1,
            :first_game_id => 1})
  
end
