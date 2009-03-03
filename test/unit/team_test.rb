require File.dirname(__FILE__) + '/../test_helper'

class TeamTest < ActiveSupport::TestCase
  
  fixtures FIXTURES[:march_madness]
  
  def test_truth
    assert true
  end
  
end
