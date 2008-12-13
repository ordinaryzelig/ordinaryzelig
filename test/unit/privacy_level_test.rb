require File.dirname(__FILE__) + '/../test_helper'

class PrivacyLevelTest < ActiveSupport::TestCase
  
  fixtures :privacy_levels, :privacy_level_types, :blogs
  
  def test_to_i
    assert_equal 3, privacy_levels(:public).to_i 
    assert_equal 2, privacy_levels(:friends).to_i 
    assert_equal 1, privacy_levels(:private).to_i 
  end
  
end
