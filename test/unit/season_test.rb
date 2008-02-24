require File.dirname(__FILE__) + '/../test_helper'

class SeasonTest < Test::Unit::TestCase
  
  fixtures :seasons
  defaults({:tournament_starts_at => '2007-03-15 06:20:00',
            :buy_in => 10,
            :max_num_brackets => 1})
  
end
