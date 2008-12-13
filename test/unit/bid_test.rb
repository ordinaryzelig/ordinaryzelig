require File.dirname(__FILE__) + '/../test_helper'

class BidTest < ActiveSupport::TestCase
  
  march_madness_fixtures
  
  defaults({:team_id => 1,
            :seed => 1,
            :first_game_id => 1})
  
end
